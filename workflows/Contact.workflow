<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Demo_Request_Notification_Contact</fullName>
        <description>Demo Request Notification - Contact</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Process_Emails/Demo_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Ad_Insertion</fullName>
        <field>Alert_Ad_Insertion_for_Multiscreen__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Ad Insertion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Automation</fullName>
        <field>Service_Alert_Automation__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Automation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Broadcast_Graphic</fullName>
        <field>Service_Alert_Broadcast_Graphics__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Broadcast Graphic</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_CloudDVR</fullName>
        <field>Alert_Cloud_DVR__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: CloudDVR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Command_Control</fullName>
        <field>Service_Alert_Command_Control__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Command &amp; Control</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Compression_Tra</fullName>
        <field>Service_Alert_Compression_Transport__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Packaging</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Digital_Signage</fullName>
        <field>Service_Alert_Digital_Signage__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Digital Signage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Edge_Server</fullName>
        <field>Alert_Edge_Server__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Edge Server</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Encoding</fullName>
        <field>Alert_Encoding__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Encoding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Multiviewers</fullName>
        <field>Service_Alert_Multiviewers__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Multiviewers</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Processing</fullName>
        <field>Service_Alert_Processing__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Processing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Routers1</fullName>
        <field>Service_Alert_Routers__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Routers1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Test_Measuremen</fullName>
        <field>Service_Alert_Test_Measurement__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Test &amp; Measuremen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Transcoding</fullName>
        <field>Alert_Transcoding__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Transcoding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Unified_Distribut</fullName>
        <field>Alert_Unified_Distribution__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Unified Distribut</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Service_Alert_Video_Servers</fullName>
        <field>Service_Alert_Servers__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Service Alert: Video Servers</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Alert_Integrated_Playout</fullName>
        <field>Service_Alert_Versio__c</field>
        <literalValue>0</literalValue>
        <name>Update Alert: Integrated Playout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>iv__InsideView_Contacts_Outbound_Message</fullName>
        <apiVersion>43.0</apiVersion>
        <description>This is used for notifying InsideView Refresh for Contacts.</description>
        <endpointUrl>https://integrations.insideview.com/integrations-notifications/salesforce/contact?authType=IV_SALESFORCE_CANVAS&amp;prefix=iv&amp;version=5.2</endpointUrl>
        <fields>AccountId</fields>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>sfdc.admin@imagine.com</integrationUser>
        <name>InsideView Contacts Outbound Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Service%3A Do Not Receive Service Alerts</fullName>
        <actions>
            <name>Uncheck_Service_Alert_Automation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Broadcast_Graphic</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Command_Control</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Compression_Tra</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Digital_Signage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Multiviewers</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Processing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Routers1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Video_Servers</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Alert_Integrated_Playout</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Do_Not_Receive_Service_Alerts__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Check this field in order to uncheck all individual service alert fields.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Do Not Receive Service Alerts 2</fullName>
        <actions>
            <name>Uncheck_Service_Alert_Ad_Insertion</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_CloudDVR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Edge_Server</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Encoding</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Test_Measuremen</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Transcoding</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Service_Alert_Unified_Distribut</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Do_Not_Receive_Service_Alerts__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Check this field in order to uncheck all individual service alert fields.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>iv__InsideView Outbound Rule for Contacts</fullName>
        <actions>
            <name>iv__InsideView_Contacts_Outbound_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>ISBLANK(&apos;&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>iv__InsideView Outbound Rule for New Contacts</fullName>
        <actions>
            <name>iv__InsideView_Contacts_Outbound_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>ISBLANK(&apos;&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>