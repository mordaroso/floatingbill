
function add_user(name, id){
    var element = document.createElement('li');
    element.innerHTML = "<input type='hidden' name='bill[user_ids][]' value='"+ id + "'>";
    element.innerHTML +=  name;
    element.innerHTML += " <a href='javascript:void(0)' onclick='remove_payer(this)'>x</a>";
    element.addClassName('user');
    $('payers').appendChild(element);
}

function add_group(name, id){
    var element = document.createElement('li');
    element.innerHTML = "<input type='hidden' name='bill[group_ids][]' value='"+ id + "'>";
    element.innerHTML +=  name;
    element.innerHTML += " <a href='javascript:void(0)' onclick='remove_payer(this)'>x</a>";
    element.addClassName('group');
    $('payers').appendChild(element);
}

function add_element(element, value){
    if(value.hasClassName('group'))
        add_group(value.innerHTML, value.down('.id').innerHTML)
    else
        add_user(value.innerHTML, value.down('.id').innerHTML)
    $('payer').value = ''
}

function remove_payer(element){
    element.up(0).remove();
}


Event.observe(window, 'load', function() {
    // Activities
    if($("activities_up")) {
        $("activities_up").observe('click', function() {
            Effect.BlindUp("activities_list");
            $("activities_down").show();
            $("activities_up").hide();
        });

        $("activities_down").observe('click', function() {
            Effect.BlindDown("activities_list");
            $("activities_up").show();
            $("activities_down").hide();
        });
    }
    if($("show_log")) {
        $("show_log").observe('click', function() {
            $("show_log").hide();
            Effect.BlindDown("logs");
        });
    }
});
