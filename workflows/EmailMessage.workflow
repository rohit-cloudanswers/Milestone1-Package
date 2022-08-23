<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Case_Last_Email_Message_Subj</fullName>
        <field>Last_Email_Message_Subject__c</field>
        <formula>Subject</formula>
        <name>Case Last Email Message Subj</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Case_Email_Subject_Date</fullName>
        <field>Last_Email_Message_Date__c</field>
        <formula>NOW()</formula>
        <name>Last Case Email Subject Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Service%3A Last Email Message Subject</fullName>
        <actions>
            <name>Case_Last_Email_Message_Subj</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Last_Case_Email_Subject_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Subject</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Service: Last Email Message Subject - update case last email subject</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
