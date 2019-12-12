<!DOCTYPE html>
<html>
<head>
<title>Trang Index</title>
<meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Home Version Two || limupa - Digital Products Store ECommerce Bootstrap 4 Template</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Favicon -->
        <link rel="shortcut icon" type="image/x-icon" href="images/favicon.png">
        <!-- Material Design Iconic Font-V2.2.0 -->
        <link rel="stylesheet" href="css/material-design-iconic-font.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="css/font-awesome.min.css">
        <!-- Font Awesome Stars-->
        <link rel="stylesheet" href="css/fontawesome-stars.css">
        <!-- Meanmenu CSS -->
        <link rel="stylesheet" href="css/meanmenu.css">
        <!-- owl carousel CSS -->
        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <!-- Slick Carousel CSS -->
        <link rel="stylesheet" href="css/slick.css">
        <!-- Animate CSS -->
        <link rel="stylesheet" href="css/animate.css">
        <!-- Jquery-ui CSS -->
        <link rel="stylesheet" href="css/jquery-ui.min.css">
        <!-- Venobox CSS -->
        <link rel="stylesheet" href="css/venobox.css">
        <!-- Nice Select CSS -->
        <link rel="stylesheet" href="css/nice-select.css">
        <!-- Magnific Popup CSS -->
        <link rel="stylesheet" href="css/magnific-popup.css">
        <!-- Bootstrap V4.1.3 Fremwork CSS -->
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <!-- Helper CSS -->
        <link rel="stylesheet" href="css/helper.css">
        <!-- Main Style CSS -->
        <link rel="stylesheet" href="style.css">
        <!-- Responsive CSS -->
        <link rel="stylesheet" href="css/responsive.css">
        <!-- Modernizr js -->
        <script src="js/vendor/modernizr-2.8.3.min.js"></script>
    <meta charset="utf-8">
    <response.CharSet = utf-8>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
   <!--  <script>
    function AmountBranch(str) { 
        alert("Hello");
        if (window.XMLHttpRequest) {
            // code for IE7+, Firefox, Chrome, Opera, Safari
            xmlhttp = new XMLHttpRequest();
        } else {
            // code for IE6, IE5
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                alert("Hello");
                // document.getElementById("AmountBranch").innerHTML = 'adv';
                // document.getElementById("AmountBranch").innerHTML = this.responseText;
            }
        };
        document.getElementById("AmountBranch").innerHTML = 'adv';
        xmlhttp.open("GET","AmountBranch.php?pmanufac="+str,true);
        xmlhttp.send();
    }
}
</script> -->
<style>
    .navbar {
      margin-bottom: 0;
      border-radius: 0;
    }
    .row.content {height: 450px}
    .sidenav {
      padding-top: 20px;
      background-color: #f1f1f1;
      height: auto;
    }
    footer {
      background-color: #555;
      color: white;
      padding: 15px;
    }
    @media screen and (max-width: 767px) {
      .sidenav {
        height: auto;
        padding: 5px;
      }
      .row.content {height:auto;}
    }
    .h3{

        border-radius: 5px;
    }
    .col-sm-4{
        border: 10px solid white;
    }
    .col-sm-2 a{
        color: #213921;
        padding:20px;
    }
    .col-sm-2 div{
        color:white;
        background-color:#B4F7B4;
        border-radius: 5px;
        font-family:Georgia;
    }
    .col-sm-2 p{
        margin:15px;
        padding:0;
        border-bottom: 1px solid #B4F7B4;
        border-left: 3px solid #B4F7B4;
        border-radius: 5px;
    }
    .col-sm-4 p{
        font-family:Verdana;
        font-style: oblique;
    }
    table tr td {
        border-bottom: 2px solid #ccc;
        padding-left: 15px;
        padding-right: 15px;
    }
    a:hover{
        color:white;
        text-decoration: none;
        display: inline-block;
    }
    a{
        color:white;
        text-decoration: none;
        display: inline-block;
    }
    Description{
        width : 100px;
    }
</style>
</head>
<body>


<?php  
    require("connect_db.php");
    $sql_sp='select * from Product()';
    $query_sp=sqlsrv_query($conn,$sql_sp);
?>
<!-- Bảng Product -->
<div class="col-sm-12">
<h1>PRODUCT</h1>
<button type="button" class="btn btn-warning"><a href="add_product.php" class="add_product">ADD</a></button>
<table class="table table-hover table-bordered">
    <thead>
        <tr class="info">
            <th>Id Product</th>
            <th>Name of product</th>
            <th>Size</th>
            <th>Description</th>
            <th>Color</th>
            <th  style="width: 30%">Img</th>
            <th>IdShop</th>
            <th>UnitPrice</th>
            <th>Amount</th>
            <th>Rate</th>
        </tr>
    </thead>
    <tbody>
        <?php while ($row = sqlsrv_fetch_array($query_sp,SQLSRV_FETCH_NUMERIC)) : ?>
            <tr>
                <td><?php echo $row[0]; ?></td>
                <td><?php echo $row[1]; ?></td>
                <td><?php echo $row[2]; ?></td>
                <td><?php echo $row[5]; ?></td>
                <td><?php echo $row[4]; ?></td>
                <td><?php echo $row[3]; ?></td>
                <td><?php echo $row[6]; ?></td>
                <td><?php echo (float)$row[7]; ?></td>
                <td><?php echo $row[8]; ?></td>
                <td><?php echo $row[9]; ?></td>
                <td><button type="button" class="btn btn-danger">
                <a href="delete_product.php?pid=<?php echo $row[0]; ?>
                " class="delete">Delete</a></button>      
                <button type="button" class="btn btn-info">
                    <a href="edit_product.php?pid=<?php echo $row[0]; ?>" class="edit">Edit</a>
                </button></td>
            </tr>
        <?php endwhile; ?>
    </tbody>
</table>

</div>
<div class="col-sm-2">

</div>
<div class="col-sm-10">
    <h3>Statistic</h3>
</div>
<div class="col-sm-2">
</div>
<!-- 
<div class="col-sm-4"> 
    <h4>Sum of Product</h4>   
    <form method="POST" role="form" action="AmountBranch.php">
        <select class="form-control mdb-select md-form colorful-select dropdown-info" name="pmanufac">
        <option disabled selected>Choose manufactor</option>
            <?php while ($row = sqlsrv_fetch_array($query_sp_1,SQLSRV_FETCH_NUMERIC)) : ?>
                <option value="<?php echo $row[0]; ?>"><?php echo $row[0]; ?></option>
            <?php endwhile; ?>
        </select>
        <br>
        <input type="submit" class="btn btn-info" value="Calculate">
    </form>
</div>
<div class="col-sm-4">    
    <h4>Average</h4> 
    <form method="POST" role="form" action="rateBranch.php">
        <select class="form-control mdb-select md-form colorful-select dropdown-info" name="rateBranch">
        <option disabled selected>Choose manufactor</option>
            <?php while ($row = sqlsrv_fetch_array($query_sp_2,SQLSRV_FETCH_NUMERIC)) : ?>
                <option value="<?php echo $row[0]; ?>"><?php echo $row[0]; ?></option>
            <?php endwhile; ?>
        </select>
        <br>
        <input type="submit" class="btn btn-info" value="Calculate">
    </form>
</div> -->