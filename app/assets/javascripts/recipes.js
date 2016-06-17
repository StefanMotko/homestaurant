// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var current_ingredients = 1;

$(document).on("click", "#ingredientAddButton",  function(){
        var clonedIngredient = $("#ingredientSelect").clone();

        current_ingredients = current_ingredients + 1;

        var modifiedIngredient = clonedIngredient.prop('outerHTML').replace(/ingredient1/g,"ingredient" + current_ingredients);

        $("#ingredientAddButtonRow").before(modifiedIngredient);
});

function discard(id, unlike) {

    var request = new XMLHttpRequest();
    request.responseType = "text";
    request.onreadystatechange = function(){
        if (request.readyState == 4 && request.status == 200)
        {
            var toReplace = $("#ingred" + id)[0];
            toReplace.outerHTML = request.responseText;
        }
    };

    var unlikeString = "";
    if (unlike) {
        unlikeString="&unlike="+id;
    }

    var syncer = $("#synchronizer")[0];

    request.open("GET","/recipes/getnext?t=" + Math.random() + "&synchronizer=" + syncer.innerHTML + unlikeString,true);
    request.send();
}