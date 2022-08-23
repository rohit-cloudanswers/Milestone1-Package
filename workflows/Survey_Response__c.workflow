<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_is_sent_to_Imagine_Communications_to_indicate_a_case_is_unresolved</fullName>
        <description>Email is sent to Imagine Communications to indicate a case is unresolved</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/Issue_Not_Closed</template>
    </alerts>
    <alerts>
        <fullName>Negative_Survey_Response_Recommendation</fullName>
        <description>Negative Survey Response Recommendation</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/Negative_Recommendation_Survey_Response</template>
    </alerts>
    <alerts>
        <fullName>Positive_Survey_Response_Recommendation</fullName>
        <description>Positive Survey Response Recommendation</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/Positive_Recommendation_Survey_Response</template>
    </alerts>
    <fieldUpdates>
        <fullName>Add_1_to_the_Account_Detractor_Count</fullName>
        <field>Service_Detractor_Count__c</field>
        <formula>IF( PRIORVALUE( Recommendation_Likelihood__c ) &gt; 6 || ISNEW(), Account__r.Service_Detractor_Count__c + 1, Account__r.Service_Detractor_Count__c)</formula>
        <name>Add 1 to the Account Detractor Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_1_to_the_Account_Promoter_Count</fullName>
        <field>Service_Promoter_Count__c</field>
        <formula>IF( PRIORVALUE( Recommendation_Likelihood__c ) &lt; 9 || ISNEW(), Account__r.Service_Promoter_Count__c + 1, Account__r.Service_Promoter_Count__c)</formula>
        <name>Add 1 to the Account Promoter Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_1_to_the_Case_Detractor_Count</fullName>
        <field>Service_Detractor_Count__c</field>
        <formula>IF( PRIORVALUE( Recommendation_Likelihood__c ) &gt; 6 || ISNEW(), Case__r.Service_Detractor_Count__c + 1, Case__r.Service_Detractor_Count__c)</formula>
        <name>Add 1 to the Case Detractor Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_1_to_the_Case_Promoter_Count</fullName>
        <field>Service_Promoter_Count__c</field>
        <formula>IF( PRIORVALUE( Recommendation_Likelihood__c ) &lt; 9 || ISNEW(), Case__r.Service_Promoter_Count__c + 1, Case__r.Service_Promoter_Count__c)</formula>
        <name>Add 1 to the Case Promoter Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Survey_Case_Owner_Manager_Email</fullName>
        <field>Case_Owner_Manager_Email__c</field>
        <formula>Case__r.Case_Owner_Manager_Email__c</formula>
        <name>Populate Survey Case Owner Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subtract_1_From_Account_Detractor_Count</fullName>
        <field>Service_Detractor_Count__c</field>
        <formula>IF( PRIORVALUE( Recommendation_Likelihood__c ) &lt;= 6 , Account__r.Service_Detractor_Count__c - 1, Account__r.Service_Detractor_Count__c )</formula>
        <name>Subtract 1 From Account Detractor Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subtract_1_From_Account_Promoter_Count</fullName>
        <field>Service_Promoter_Count__c</field>
        <formula>IF( PRIORVALUE( Recommendation_Likelihood__c ) &gt;= 9 , Account__r.Service_Promoter_Count__c - 1, Account__r.Service_Promoter_Count__c )</formula>
        <name>Subtract 1 From Account Promoter Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subtract_1_From_Case_Detractor_Count</fullName>
        <field>Service_Detractor_Count__c</field>
        <formula>IF( PRIORVALUE( Recommendation_Likelihood__c ) &lt;= 6 , Case__r.Service_Detractor_Count__c - 1, Case__r.Service_Detractor_Count__c )</formula>
        <name>Subtract 1 From Case Detractor Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subtract_1_From_Case_Promoter_Count</fullName>
        <field>Service_Promoter_Count__c</field>
        <formula>IF( PRIORVALUE( Recommendation_Likelihood__c ) &gt;= 9, Case__r.Service_Promoter_Count__c - 1, Case__r.Service_Promoter_Count__c )</formula>
        <name>Subtract 1 From Case Promoter Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Responder_Email</fullName>
        <field>Responder_Email__c</field>
        <formula>Case__r.Contact.Email</formula>
        <name>Update Survey Responder Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Responder_Name</fullName>
        <field>Responder_Name__c</field>
        <formula>Case__r.Contact.FirstName  &amp; &quot; &quot; &amp;  Case__r.Contact.LastName</formula>
        <name>Update Survey Responder Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Service%3A Add Tally To Detractor Field</fullName>
        <actions>
            <name>Add_1_to_the_Account_Detractor_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Add_1_to_the_Case_Detractor_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Subtract_1_From_Account_Promoter_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Subtract_1_From_Case_Promoter_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Response__c.Recommendation_Likelihood__c</field>
            <operation>lessOrEqual</operation>
            <value>6</value>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Response__c.Recommendation_Likelihood__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Every time this fires, the Service Detractor Count on the case will be increased by 1.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Add Tally To Promoter Field</fullName>
        <actions>
            <name>Add_1_to_the_Account_Promoter_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Add_1_to_the_Case_Promoter_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Subtract_1_From_Account_Detractor_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Subtract_1_From_Case_Detractor_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Response__c.Recommendation_Likelihood__c</field>
            <operation>greaterOrEqual</operation>
            <value>9</value>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Response__c.Recommendation_Likelihood__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Every time this fires, the Service Promoter Count on the case will be increased by 1.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Add or Subtract Tally</fullName>
        <actions>
            <name>Subtract_1_From_Account_Detractor_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Subtract_1_From_Account_Promoter_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Subtract_1_From_Case_Detractor_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Subtract_1_From_Case_Promoter_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Survey_Response__c.Recommendation_Likelihood__c</field>
            <operation>equals</operation>
            <value>8</value>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Response__c.Recommendation_Likelihood__c</field>
            <operation>equals</operation>
            <value>7</value>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Response__c.Recommendation_Likelihood__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Every time this fires, the Service Promoter or Detractor Counts on the case and account will be decreased by 1.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Issue Not Closed Survey Email</fullName>
        <actions>
            <name>Email_is_sent_to_Imagine_Communications_to_indicate_a_case_is_unresolved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Response__c.Issue_Closed__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <description>When survey response claims that the issue was not resolved, a notification email is sent to the service team.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Negative Likelihood Survey Email</fullName>
        <actions>
            <name>Negative_Survey_Response_Recommendation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Response__c.Recommendation_Likelihood__c</field>
            <operation>lessOrEqual</operation>
            <value>7</value>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Response__c.Recommendation_Likelihood__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When survey response has Recommendation Likelihood of 7 or less, a notification email is sent to the service team.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Populate Case Owner Manager Email</fullName>
        <actions>
            <name>Populate_Survey_Case_Owner_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Response__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow populates the Case Owner Manager Email field on the survey response record from the case.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Populate Survey Responder Email</fullName>
        <actions>
            <name>Update_Survey_Responder_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Response__c.Responder_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This checks if the Survey Responder Email field is populated. If not, the case contact email value populates this.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Populate Survey Responder Name</fullName>
        <actions>
            <name>Update_Survey_Responder_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Response__c.Responder_Name__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This checks if the Survey Responder Name field is populated. If not, the case contact name value populates this.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Positive Likelihood Survey Email</fullName>
        <actions>
            <name>Positive_Survey_Response_Recommendation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Response__c.Recommendation_Likelihood__c</field>
            <operation>greaterOrEqual</operation>
            <value>9</value>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Response__c.Recommendation_Likelihood__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When survey response has Recommendation Likelihood of 9 or greater, a notification email is sent to the service team.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
