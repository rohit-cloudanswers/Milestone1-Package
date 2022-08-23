<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Oracle_Repair_Email</fullName>
        <description>Oracle Repair Email</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Oracle_Repair_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Repair_Case_Owner_Email</fullName>
        <description>Repair Case Owner Email</description>
        <field>Case_Owner_Email__c</field>
        <formula>Order__r.Case__r.Owner:User.Email</formula>
        <name>Repair Case Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Send Email on Repair Creation</fullName>
        <actions>
            <name>Oracle_Repair_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Repair_Case_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Oracle_Repair__c.Case_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Send Email on Repair Creation to Case Owner associated to Order that&apos;s associated to Repair</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
