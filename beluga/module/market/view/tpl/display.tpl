<link rel="stylesheet" href="/beluga/market/css/display"/>
::if (market_error != "")::
    <div class="alert alert-danger alert-dismissable ticket-alert-error">
        <strong>Error!</strong> ::market_error::
    </div>
::end::
::if (market_info != "")::
    <div class="alert alert-info alert-dismissable ticket-alert-error">
        <strong>Information !</strong> ::market_info::
    </div>
::end::
<div class="row">
::foreach product_list::
  <div class="col-sm-2 col-md-2">
    <div class="thumbnail">
      <img src="http://placehold.it/200x150" alt="product">
      <div class="caption">
        <h3>::product_name::</h3>
        <p>::product_price:: ::currency::</p>
        <p>::product_desc::</p>
        <p><a href="/beluga/market/addProductToCart?id=::product_id::" class="btn btn-info" role="button">Ajouter au panier</a></p>
      </div>
    </div>
  </div>
::end::
</div>