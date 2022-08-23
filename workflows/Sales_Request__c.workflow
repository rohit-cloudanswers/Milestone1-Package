<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Managed_Service_Request</fullName>
        <ccEmails>hal.york@imaginecommunications.com;Steve.Paoletti@imaginecommunications.com</ccEmails>
        <description>Send Managed Service Request</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>harsh.patel@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lisa.cline@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>paul.nagle@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>richard.parker@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shaun.kerrick@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Notifications/Managed_Service_Quote_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Opportunity_Description</fullName>
        <description>Update Opportunity Description on Sales request</description>
        <field>Opportunity_Description__c</field>
        <formula>Opportunity__r.Description</formula>
        <name>Update Opportunity Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Managed Service Request</fullName>
        <actions>
            <name>Send_Managed_Service_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Opportunity_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Sales_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Managed Service</value>
        </criteriaItems>
        <description>Managed Service Request</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
