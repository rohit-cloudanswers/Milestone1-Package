<aura:application controller="OneDriveController">
    <ltng:require 
		scripts="{!join(',', $Resource.webapp + '/sweetalert2.helper.js')}" 
		afterScriptsLoaded="{!c.afterScriptsLoaded}" />
	<aura:attribute name="code" type="String"/>
    <aura:attribute name="state" type="String"/>
</aura:application>