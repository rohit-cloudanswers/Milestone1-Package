<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Demo_Request_Notifiaction</fullName>
        <description>Demo Request Notifiaction</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Process_Emails/Demo_Notification</template>
    </alerts>
    <alerts>
        <fullName>Unread_MQL_Reminder</fullName>
        <description>Unread MQL Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>richard.scott@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Process_Emails/Unread_MQL_Reminder</template>
    </alerts>
    <outboundMessages>
        <fullName>iv__Lead_Outbound_Message</fullName>
        <apiVersion>43.0</apiVersion>
        <description>This is used for notifying InsideView Refresh for Leads.</description>
        <endpointUrl>https://integrations.insideview.com/integrations-notifications/salesforce/lead?authType=IV_SALESFORCE_CANVAS&amp;prefix=iv&amp;version=5.2</endpointUrl>
        <fields>CreatedById</fields>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>sfdc.admin@imagine.com</integrationUser>
        <name>InsideView Leads Outbound Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>iv__InsideView Outbound Rule for Leads</fullName>
        <actions>
            <name>iv__Lead_Outbound_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>ISBLANK(&apos;&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>iv__InsideView Outbound Rule for New Leads</fullName>
        <actions>
            <name>iv__Lead_Outbound_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>ISBLANK(&apos;&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
