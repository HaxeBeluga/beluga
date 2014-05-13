::if (market_cart_error != "")::
    <div class="alert alert-danger alert-dismissable ticket-alert-error">
        <strong>Error!</strong> ::market_cart_error::
    </div>
::else::
::if (market_cart_info != "")::
    <div class="alert alert-info alert-dismissable ticket-alert-error">
        <strong>Information !</strong> ::market_cart_info::
    </div>
::else::
<div class="container">
    <div class="row">
        <div class="col-sm-12 col-md-10 col-md-offset-1">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th class="text-center">Price</th>
                        <th class="text-center">Total</th>
                        <th> </th>
                    </tr>
                </thead>
                <tbody>
                    ::foreach products_list::
                    <tr>
                        <td class="col-sm-8 col-md-6">
                        <div class="media">
                            <a class="thumbnail pull-left" href="#"> <img class="media-object" src="http://icons.iconarchive.com/icons/custom-icon-design/flatastic-2/72/product-icon.png" style="width: 72px; height: 72px;"> </a>
                            <div class="media-body">
                                <h4 class="media-heading"><a href="#">::product_name::</a></h4>
                                <h5 class="media-heading"> by <a href="#"></a></h5>
                                <span>Status: </span><span class="text-success"><strong>In Stock</strong></span>
                            </div>
                        </div></td>
                        <td class="col-sm-1 col-md-1" style="text-align: center">
                        <input type="email" class="form-control" id="exampleInputEmail1" value="::product_quantity::">
                        </td>
                        <td class="col-sm-1 col-md-1 text-center"><strong>::currency:: ::product_price::</strong></td>
                        <td class="col-sm-1 col-md-1 text-center"><strong>::currency:: ::product_total_price::</strong></td>
                        <td class="col-sm-1 col-md-1">
                        <a href="/beluga/market/removeProductInCart?id=::product_cart_id::" type="button" class="btn btn-danger">
                            <span class="glyphicon glyphicon-remove"></span> Remove
                        </a></td>
                    </tr>
                    ::end::
                    <tr>
                        <td>   </td>
                        <td>   </td>
                        <td>   </td>
                        <td><h3>Total</h3></td>
                        <td class="text-right"><h3><strong>::currency:: ::total_price::</strong></h3></td>
                    </tr>
                    <tr>
                        <td>   </td>
                        <td>   </td>
                        <td>   </td>
                        <td>   </td>
                        <td>
                        <a href="/beluga/market/checkoutCart" type="button" class="btn btn-success">
                            Checkout <span class="glyphicon glyphicon-play"></span>
                        </a></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
::end::
::end::