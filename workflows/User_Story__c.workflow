<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>User_Story_Ready_for_Production_Deployment</fullName>
        <description>User Story Ready for Production Deployment</description>
        <protected>false</protected>
        <recipients>
            <recipient>david.poling@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jeffrey.kurth@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Imagine_Emails/User_Story_Ready_for_Production_Deployment</template>
    </alerts>
    <alerts>
        <fullName>User_Story_has_Failed_QA_Testing</fullName>
        <description>User Story has Failed QA Testing</description>
        <protected>false</protected>
        <recipients>
            <recipient>lane.lobaugh@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Imagine_Emails/User_Story_has_Failed_QA_Testing</template>
    </alerts>
    <rules>
        <fullName>User Story Ready for Production Deployment</fullName>
        <actions>
            <name>User_Story_Ready_for_Production_Deployment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User_Story__c.Status__c</field>
            <operation>equals</operation>
            <value>Ready for Deployment</value>
        </criteriaItems>
        <description>User Story Ready for Production Deployment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>User Story Ready for QA</fullName>
        <active>false</active>
        <criteriaItems>
            <field>User_Story__c.Status__c</field>
            <operation>equals</operation>
            <value>Validation / QA</value>
        </criteriaItems>
        <description>User Story Ready for QA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>User Story has Failed QA Testing</fullName>
        <actions>
            <name>User_Story_has_Failed_QA_Testing</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User_Story__c.Status__c</field>
            <operation>equals</operation>
            <value>Failed</value>
        </criteriaItems>
        <description>User Story has Failed QA Testing</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
