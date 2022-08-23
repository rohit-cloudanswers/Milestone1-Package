<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Order_Demo_Reminder</fullName>
        <description>Order Demo Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Demo_Reminder_Recipient_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Demo_Reminder_Recipient_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>lane.lobaugh@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>llobaugh@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Order/Demo_End_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Work_Order_Complete</fullName>
        <description>Work Order Complete</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Alternate_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Case_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/Work_Order_Complete</template>
    </alerts>
    <fieldUpdates>
        <fullName>Category_Expired</fullName>
        <field>Catagory__c</field>
        <literalValue>EXPIRED</literalValue>
        <name>Category Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_After_Acceptance</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Work_Order_Header</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type After Acceptance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_order_record_type_to_Work_Order</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Work_Order</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change order record type to &quot;Work Order&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Case_Alternate_Email_on_Order</fullName>
        <field>Case_Alternate_Email__c</field>
        <formula>Case__r.Alternate_Email__c</formula>
        <name>Populate Case Alternate Email on Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Case_Contact_Email_on_Order</fullName>
        <field>Case_Contact_Email__c</field>
        <formula>Case__r.Contact.Email</formula>
        <name>Populate Case Contact Email on Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Order_Note</fullName>
        <description>Update Order Note</description>
        <field>Order_Note__c</field>
        <formula>LEFT(Shipping_Instructions__c,150)</formula>
        <name>Update Order Note</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Demo End Date - Expiration Date Logic</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Order.Demo_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Order.Catagory__c</field>
            <operation>equals</operation>
            <value>CURRENT</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Category_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Order.Demo_End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Service%3A Change Record Type after Acceptance</fullName>
        <actions>
            <name>Change_Record_Type_After_Acceptance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Order Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Change Record Type after Submission</fullName>
        <actions>
            <name>Change_order_record_type_to_Work_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Order Header</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order.Submitted_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Copy Shipping Instructions to Order Note</fullName>
        <actions>
            <name>Update_Order_Note</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order.Copy_Shipping_Instructions_to_Order_Note__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order.Order_Note__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Service: Copy Shipping Instructions to Order Note</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Email Case Contact when Work Order is Completed</fullName>
        <actions>
            <name>Work_Order_Complete</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Order.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order.Oracle_Order_Status__c</field>
            <operation>equals</operation>
            <value>Booked</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order.Oracle_Order_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Update Order Contact Emails</fullName>
        <actions>
            <name>Populate_Case_Alternate_Email_on_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Case_Contact_Email_on_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
