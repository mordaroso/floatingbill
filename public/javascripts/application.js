function add_payer(){
  var element = document.createElement('li');
  if($('payer_type').value == "group")
    element.innerHTML = "<input type='hidden' name='bill[group_names][]' value='"+$('payer').value+ "'>";
  else
    element.innerHTML = "<input type='hidden' name='bill[payer_names][]' value='"+$('payer').value+ "'>";
  
  element.innerHTML +=  $('payer').value;
  element.innerHTML += " <a href='javascript:void(0)' onclick='remove_payer(this)'>x</a>";
  element.addClassName($('payer_type').value);
  $('payers').appendChild(element);
}

function remove_payer(element){
  element.up(0).remove();
}
