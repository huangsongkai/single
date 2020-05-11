package v1.grade;

//import com.mchange.v2.c3p0.ComboPooledDataSource;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.Pair;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

public class DBHelper {
    private static DBHelper reader = new DBHelper("java:comp/env/jdbc/mysqldb_read", "mysqldb_read");
    private static DBHelper writer = new DBHelper("java:comp/env/jdbc/mysqldb_write", "mysqldb_write");

    public static DBHelper getReader() {
        return reader;
    }

    public static DBHelper getWriter() {
        return writer;
    }

    private DBHelper(String jndi, String c3p0) {
        this.jndi = jndi;
        this.c3p0 = c3p0;
        rebuildDataSource();
    }

    public void rebuildDataSource() {
        try {
            Context initCtx = new InitialContext();
            dataSource = (DataSource) initCtx.lookup(jndi);
        } catch (NamingException e) {
            e.printStackTrace();
            dataSource = new ComboPooledDataSource(c3p0);
        }
    }

    public Connection connect() {
        if (dataSource == null) {
            rebuildDataSource();
        }
        if (dataSource != null) {
            try {
                return dataSource.getConnection();
            } catch (SQLException e) {
                throw new GradeException(DBHelper.class.getName(), 43, "无法创建数据源连接", e);
            }
        }
        throw new GradeException(DBHelper.class.getName(), 46, "无法创建数据源连接");
    }

    @Deprecated
    public List<Map<String, Object>> doQuery(String sql, Object[] params, String[] keys) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        Connection reader = null;
        PreparedStatement query = null;
        try {
            reader = connect();
            query = reader.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                query.setObject(i + 1, params[i]);
            }
            ResultSet rs = query.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<String, Object>();
                for (int i = 0; i < keys.length; i++) {
                    map.put(keys[i], rs.getObject(i + 1));
                }
                list.add(map);
            }
        } finally {
            if (query != null) {
                query.close();
            }
            if (reader != null) {
                reader.close();
            }
        }
        return list;
    }

    public List<Map<String, Object>> doQuery(String sql, Object[] params, List<Pair<String, ResultType>> keyAndTypes) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        Connection reader = null;
        PreparedStatement query = null;
        try {
            reader = connect();
            query = reader.prepareStatement(sql);

            for (int i = 0; i < params.length; i++) {
                query.setObject(i + 1, params[i]);
            }
            ResultSet rs = query.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<String, Object>();
                for (int i = 0; i < keyAndTypes.size(); i++) {
                    String key = keyAndTypes.get(i).getKey();
                    ResultType resultType = keyAndTypes.get(i).getValue();
                    map.put(key, resultType.getParameter(rs, i + 1));
                }
                list.add(map);
            }
        } finally {
            if (query != null) query.close();
            if (reader != null) reader.close();

        }
        return list;
    }

    public static List<Pair<String, ResultType>> keyAndTypes(Object... keyAndTypes) {
        if (keyAndTypes.length % 2 != 0) {
            throw new GradeException(DBHelper.class.getName(), 46, "Parameters function requires an even number of arguments, alternating key and value. Arguments were: " + Arrays.toString(keyAndTypes) + ".");
        } else {
            List<Pair<String, ResultType>> list = new ArrayList<Pair<String, ResultType>>();
            for (int i = 0; i < keyAndTypes.length; i += 2) {
                Object value = keyAndTypes[i + 1];
                if (!(value instanceof ResultType)) {
                    throw new GradeException(DBHelper.class.getName(), 46, "参数类型错误！");
                }
                list.add(new ImmutablePair<String, ResultType>(keyAndTypes[i].toString(), (ResultType) value));
            }

            return list;
        }
    }

    public enum ResultType {
        STRING, SHORT, INTEGER, LONG, DOUBLE, DATE, TIME, OBJECT, BOOLEAN, TIMESTAMP, DATE_AS_LONG, LIST;

        public Object getParameter(ResultSet resultSet, int columnIndex) throws SQLException {
            switch (this) {
                case INTEGER:
                    return resultSet.getInt(columnIndex);
                case DOUBLE:
                    return resultSet.getDouble(columnIndex);
                case SHORT:
                    return resultSet.getShort(columnIndex);
                case LONG:
                    return resultSet.getLong(columnIndex);
                case STRING:
                    return resultSet.getString(columnIndex);
                case BOOLEAN:
                    return resultSet.getBoolean(columnIndex);
                case DATE:
                    return resultSet.getDate(columnIndex);
                case TIMESTAMP:
                    return resultSet.getTimestamp(columnIndex);
                case TIME:
                    return resultSet.getTime(columnIndex);
                case DATE_AS_LONG:
                    Timestamp timestamp = resultSet.getTimestamp(columnIndex);
                    return timestamp == null ? 0 : timestamp.getTime();
                default:
                    return resultSet.getObject(columnIndex);
            }
        }
    }

    public int doUpdate(String sql, Object... params) throws SQLException {
        Connection writer = null;
        PreparedStatement query = null;
        try {
            writer = connect();
            query = writer.prepareStatement(sql);

            writer.setAutoCommit(false);
            for (int i = 0; i < params.length; i++) {
                query.setObject(i + 1, params[i]);
            }
            int affect = query.executeUpdate();
            writer.commit();
            return affect;
        } finally {
            if (query != null) query.close();
            if (writer != null) writer.close();
        }
    }

    public void doExecute(SqlUpdate sqlUpdate) throws SQLException {
        Connection writer = null;
        try {
            writer = connect();

            writer.setAutoCommit(false);
            sqlUpdate.acceptConnection(writer);
            writer.commit();
        } finally {
            if (writer != null) {
                writer.close();
            }
        }
    }

    public interface SqlUpdate {
        void acceptConnection(Connection connection) throws SQLException;
    }

    private DataSource dataSource;
    private String jndi;
    private String c3p0;
}
