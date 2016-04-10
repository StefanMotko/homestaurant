// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var current_ingredients = 1;

$(document).ready(function(){
    $("#ingredientAddButton").click(function(){
        var clonedIngredient = $("#ingredientSelect").clone();

        current_ingredients = current_ingredients + 1;

        var modifiedIngredient = clonedIngredient.prop('outerHTML').replace(/1/g,current_ingredients);

        $("#ingredientAddButtonRow").before(modifiedIngredient);
    })
})