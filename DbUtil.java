import java.sql.*;
import java.io.*;
import java.text.*;
import java.util.Date;
import java.util.Properties;
import java.util.ArrayList;

class Book{
    public String bookName;
    public String author;
    public String isbn;
    public String barcode;
    public String publisher;
    public String type;
    public int price;
    public String borrowDate;
    public String returnDate;
    public String position;
    public String searchno;
    public String state;
}
public class DbUtil{
	private static Connection conn;
	private static String driverName;
    private static String url;
    private static String user;
    private static String password;

    public String userID = null;
    private int adminFlag = 0;
    

    static {
        try {
            InputStream in = DbUtil.class.getClassLoader()
                    .getResourceAsStream("dblab.properties");
            Properties properties = new Properties();
            properties.load(in);
 
            driverName = properties.getProperty("driverName");
            url = properties.getProperty("url");
            user = properties.getProperty("user");
            password = properties.getProperty("password");
 
            Class.forName(driverName);
            conn = DriverManager.getConnection(url, user, password);

        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e){
            e.printStackTrace();
        }
    }
    public static void release(){
        if(conn!=null){
            try{
                conn.close();
            }catch(SQLException e){
                e.printStackTrace();
            }
        }
    }
    /* check user when login
     * no such user return -1
     * password uncorrect return 0
     * user return 1
     * admin return 2
     */
    public int login(String un, String pwd){
    	Statement st = null;
        ResultSet rs = null;
        PreparedStatement ps = null;
        int flag = -1;
        try{
            st = conn.createStatement();
            rs = st.executeQuery("select * from user;");
            while(rs.next() && flag==-1){
                if(rs.getString("userID").equals(un)){
                    flag = 0;
                    if(rs.getString("password").equals(pwd)){
                        flag = 1;
                        adminFlag = 0;
                    }
                }
            }
            st = conn.createStatement();
            rs = st.executeQuery("select * from adminuser;");
            while(rs.next() && flag==-1){
                if(rs.getString("adminID").equals(un)){
                    flag = 0;
                    if(rs.getString("password").equals(pwd)){
                        flag = 2;
                        adminFlag = 1;
                    }
                }
            }
            if(flag==1){
                ps = conn.prepareStatement("select readerid from userdetail where userid=?;");
                ps.setString(1,un);
                rs = ps.executeQuery();
                if(rs.next())userID = rs.getString("readerid");
            }
            rs.close();
            if(ps!=null)
                ps.close();
            st.close();
        }catch(SQLException e){
            e.printStackTrace();
        }
        return flag;
    }
    //based barcode
    public  void borrowBook(String barcode){
        if(userID==null){
            logError("请先登录");
            return ;
        }
        PreparedStatement ps = null;
        try{   
            ps = conn.prepareStatement("insert into borrow (readerid,barcode,borrowdate) values(?,?,?);");
            ps.setString(1, userID);
            ps.setString(2, barcode);
            Date dNow = new Date();
            SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd");
            ps.setString(3, ft.format(dNow));
            ps.executeUpdate();
            
            ps = conn.prepareStatement("update book set state='借出', historyborrowed=historyborrowed+1 where barcode=?;");
            ps.setString(1, barcode);            
            ps.executeUpdate();

            ps.close();
        }catch(SQLException e){
            e.printStackTrace();
        }
    }
    //based barcode
    public  void returnBook(String barcode){
        if(userID==null){
            logError("请先登录");
            return ;
        }
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement("update borrow set returndate=? where readerid=? and barcode=?;");
            Date dNow = new Date();
            SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd");
            ps.setString(1, ft.format(dNow));
            ps.setString(2, userID);
            ps.setString(3, barcode);
            ps.executeUpdate();
            
            ps = conn.prepareStatement("update book set state='可借' where barcode=?;");
            ps.setString(1, barcode);            
            ps.executeUpdate();
            

            ps.close();
        }catch(SQLException e){
            e.printStackTrace();
        }
    }
    public String searchByName(String bookName){
        String bc = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            ps = conn.prepareStatement(" select * from book,books where books.searchno=book.searchno and state='可借' and bookname=?;");
            ps.setString(1, bookName);
            rs = ps.executeQuery();
            if(rs.next()){
                bc = rs.getString("barcode");
                System.out.println(rs.getString("bookname") + " " +rs.getString("author") + " " +rs.getString("publisher") + " " +rs.getString("isbn") + " " + rs.getString("position"));
            }
            rs.close();
            ps.close();
        }catch(SQLException e){
            e.printStackTrace();
        } 
        return bc;
    }
    public ArrayList<Book> showHistoryBorrowedBooks(){
        if(userID==null){
            logError("请先登录");
            return null;
        }
        ArrayList<Book> hb = new ArrayList<Book>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            ps = conn.prepareStatement("select * from borrow,book,books where book.searchno=books.searchno and borrow.barcode=book.barcode and readerid=? and returndate is not NULL;");
            ps.setString(1, userID);
            rs = ps.executeQuery();
            if(rs.next()){
                Book book = new Book();
                book.bookName = rs.getString("bookName");
                book.author = rs.getString("author");
                book.isbn = rs.getString("isbn");
                book.publisher = rs.getString("publisher");
                book.type = rs.getString("type");
                book.price = rs.getInt("price");
                book.borrowDate = rs.getString("borrowDate");
                book.returnDate = rs.getString("returnDate");
                book.position = rs.getString("position");
                book.barcode = rs.getString("barcode");
                hb.add(book);    
            }
            rs.close();
            ps.close();
        }catch(SQLException e){
            e.printStackTrace();
        }
        return hb; 
    }
    public ArrayList<Book> showCurrentBorrowedBooks(){
        if(userID==null){
            logError("请先登录");
            return null;
        }
        ArrayList<Book> hb = new ArrayList<Book>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            ps = conn.prepareStatement("select * from borrow,book,books where book.searchno=books.searchno and borrow.barcode=book.barcode and readerid=? and returndate is NULL;");
            ps.setString(1, userID);
            rs = ps.executeQuery();
            if(rs.next()){
                Book book = new Book();
                book.bookName = rs.getString("bookName");
                book.author = rs.getString("author");
                book.isbn = rs.getString("isbn");
                book.publisher = rs.getString("publisher");
                book.type = rs.getString("type");
                book.price = rs.getInt("price");
                book.borrowDate = rs.getString("borrowDate");
                book.returnDate = rs.getString("returnDate");
                book.position = rs.getString("position");
                book.barcode = rs.getString("barcode");
                hb.add(book);    
            }
            rs.close();
            ps.close();
        }catch(SQLException e){
            e.printStackTrace();
        }
        return hb; 
    }
    public void showBooksOrdeByBorrowNum(){
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            ps = conn.prepareStatement("select bookname,sum(historyborrowed) as sum_h from books, book where books.searchno=book.searchno  group by book.searchno order by sum(historyborrowed) desc;");
            rs = ps.executeQuery();
            if(rs.next()){
                System.out.println(rs.getString("bookname") + " " + rs.getString("sum_h"));
            }
            rs.close();
            ps.close();
        }catch(SQLException e){
            e.printStackTrace();
        }
    }
    public void addBook(Book book){
        if(adminFlag==0){
            logError("没有权限");
            return;
        }
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement("insert into book values (?,?,?,?,0);");
            ps.setString(1, book.barcode);
            ps.setString(2, book.searchno);
            ps.setString(3, book.position);
            ps.setString(4, book.state);    
            ps.executeUpdate();

            ps = conn.prepareStatement("update books set num=num+1 where searchno=?;");
            ps.setString(1, book.searchno);
            ps.executeUpdate();

            ps.close();
        }catch(SQLException e){
            e.printStackTrace();
        } 
    }
    public void addBooks(Book book){
        if(adminFlag==0){
            logError("没有权限");
            return;
        }
        PreparedStatement ps = null;
        try{
            ps = conn.prepareStatement("insert into books values (?,?,?,?,?,?,?,0);");
            ps.setString(1, book.searchno);
            ps.setString(2, book.isbn);
            ps.setString(3, book.bookName);
            ps.setString(4, book.publisher);
            ps.setString(5, book.author);
            ps.setString(6, book.type);
            ps.setInt(7, book.price);
            ps.executeUpdate();

            ps.close();
        }catch(SQLException e){
            e.printStackTrace();
        } 
    }
    private void logError(String str){
        System.out.println(str);
    }
}
