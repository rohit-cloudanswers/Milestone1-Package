<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Sharing_Region</fullName>
        <field>Sharing_Region__c</field>
        <formula>Bill_To_Region__c</formula>
        <name>Update Sharing Region</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>iv__Refresh_Accounts_Outbound_Message</fullName>
        <apiVersion>43.0</apiVersion>
        <description>This is used for notifying InsideView Refresh for Accounts.</description>
        <endpointUrl>https://integrations.insideview.com/integrations-notifications/salesforce/account?authType=IV_SALESFORCE_CANVAS&amp;prefix=iv&amp;version=5.2</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>sfdc.admin@imagine.com</integrationUser>
        <name>InsideView Accounts Outbound Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Update Sharing Region</fullName>
        <actions>
            <name>Update_Sharing_Region</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates Sharing Region from Bill To Region</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>iv__InsideView Outbound Rule for Accounts</fullName>
        <actions>
            <name>iv__Refresh_Accounts_Outbound_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>ISBLANK(&apos;&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>iv__InsideView Outbound Rule for New Accounts</fullName>
        <actions>
            <name>iv__Refresh_Accounts_Outbound_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>ISBLANK(&apos;&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
