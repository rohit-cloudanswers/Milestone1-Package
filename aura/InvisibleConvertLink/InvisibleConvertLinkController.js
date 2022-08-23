({
	hideConvertLink :  function(component, event, helper){
		var aClick = document.querySelector('[title="Convert"]');
		if(aClick != null){
			aClick.style.display = "none";
		}
	}
})