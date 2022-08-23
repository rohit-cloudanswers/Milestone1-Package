<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>China_Approval</fullName>
        <description>China Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>andy.hui@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>crystal.lee@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jason.li@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lane.lobaugh@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Approval_Assignment_Email</template>
    </alerts>
    <alerts>
        <fullName>Final_Quote_Approval</fullName>
        <description>Final Quote Approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>lane.lobaugh@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>phil.whitebloom@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/NA_Quote_Approved</template>
    </alerts>
    <alerts>
        <fullName>NA_Regional_Alert</fullName>
        <description>NA Regional Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Approval_Assignment_Email</template>
    </alerts>
    <alerts>
        <fullName>NA_Regional_Rejection_Alert</fullName>
        <description>NA Regional Rejection Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Account Director</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Bid Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contributor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Enterprise Solutions Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Service</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner User</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales/SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Admin</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Siebel Migration</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Solutions Architect</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Status_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_Recall</fullName>
        <description>Quote Recall</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Recall</template>
    </alerts>
    <alerts>
        <fullName>Quote_Recall_NA</fullName>
        <description>Quote Recall</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Account Director</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Bid Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contributor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Enterprise Solutions Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Service</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner User</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales/SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Admin</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Siebel Migration</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Solutions Architect</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Recall</template>
    </alerts>
    <alerts>
        <fullName>Quote_Rejection</fullName>
        <description>Quote Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Account Director</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Bid Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contributor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Enterprise Solutions Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Service</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner User</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales/SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Admin</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Siebel Migration</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Solutions Architect</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Status_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_Rejection_Alert</fullName>
        <description>Quote Rejection Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Status_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_Rejection_China</fullName>
        <description>Quote Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Account Director</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Bid Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contributor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Enterprise Solutions Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Service</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner User</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales/SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Admin</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Siebel Migration</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Solutions Architect</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Status_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_Status_has_changed</fullName>
        <description>Quote Status has changed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Account Director</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Bid Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contributor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Enterprise Solutions Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Service</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner User</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales/SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Admin</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Siebel Migration</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Solutions Architect</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Status_Changed</template>
    </alerts>
    <alerts>
        <fullName>Quote_rejection_Email</fullName>
        <description>Quote rejection Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Director</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Bid Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contributor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Enterprise Solutions Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Service</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner User</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales/SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Admin</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Siebel Migration</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Solutions Architect</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Status_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_rejection_Email_ANZA</fullName>
        <description>Quote rejection Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Director</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Bid Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contributor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Enterprise Solutions Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Service</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner User</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales/SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Admin</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Siebel Migration</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Solutions Architect</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Status_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_rejection_Email_China</fullName>
        <description>Quote rejection Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Director</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Bid Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contributor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Enterprise Solutions Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Service</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner User</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales/SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Admin</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Siebel Migration</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Solutions Architect</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Status_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_rejection_Email_ME</fullName>
        <description>Quote rejection Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Director</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Bid Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contributor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Enterprise Solutions Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Service</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner User</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales/SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Admin</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Siebel Migration</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Solutions Architect</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Status_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_rejection_Email_SE</fullName>
        <description>Quote rejection Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Director</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Bid Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contributor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Enterprise Solutions Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Service</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner User</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales/SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Admin</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Siebel Migration</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Solutions Architect</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Status_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_rejection_Email_UKISA</fullName>
        <description>Quote rejection Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Director</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Bid Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Contributor</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Enterprise Solutions Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Service</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>ISR</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner User</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales/SE</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>RSM</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Admin</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Siebel Migration</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Solutions Architect</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Status_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Default_Text_of_Cover_Sheet_Comments</fullName>
        <field>Cover_Sheet_Comments__c</field>
        <formula>&quot;Based on the discussions we have had and an analysis of your requirements, I am pleased to offer the attached proposal.&lt;br&gt;&lt;br&gt;Please review at your earliest convenience.&lt;br&gt;&lt;br&gt;Should you have any questions or require any additional information, please feel free to contact me.&lt;br&gt;&lt;br&gt;Sincerely,&quot;</formula>
        <name>Default Text of Cover Sheet Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Address_Fields_False</fullName>
        <field>Populate_Address_fields__c</field>
        <literalValue>0</literalValue>
        <name>Populate Address Fields = False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Address_Fields_True</fullName>
        <field>Populate_Address_fields__c</field>
        <literalValue>1</literalValue>
        <name>Populate Address Fields = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Quote Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Status_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Quote Status to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Quote Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Replace_with_Contact_Email</fullName>
        <field>Email</field>
        <formula>Contact.Email</formula>
        <name>Replace with Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Replace_with_Contact_Fax</fullName>
        <field>Fax</field>
        <formula>Contact.Fax</formula>
        <name>Replace with Contact Fax</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Replace_with_Contact_Phone</fullName>
        <field>Phone</field>
        <formula>Contact.Phone</formula>
        <name>Replace with Contact Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_back_to_Draft_for_Recall</fullName>
        <field>Status</field>
        <literalValue>Draft</literalValue>
        <name>Status back to Draft for Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateExpirationDate</fullName>
        <description>Default the quote expiration date to creation date plus 30 days. The User should be able to manually override this date.</description>
        <field>ExpirationDate</field>
        <formula>CreatedDate + 30</formula>
        <name>UpdateExpirationDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Imagine_Quote_Number</fullName>
        <field>Imagine_Quote_Number__c</field>
        <formula>IF(CONTAINS(Imagine_Quote_Number__c, &quot;IC&quot;), 

/* if already has ic#, just continue that id */

IF(CONTAINS(Imagine_Quote_Number__c, &quot;-V&quot;), 
LEFT(Imagine_Quote_Number__c,FIND(&quot;-V&quot;, Imagine_Quote_Number__c)-1),
Imagine_Quote_Number__c
)
&amp;&quot;-V&quot;&amp;TEXT(Quote_Version__c)
,

/* if no ic# then we start with the quote number */

&quot;IC-&quot;+QuoteNumber&amp;&quot;-V&quot;&amp;TEXT(Quote_Version__c)

)</formula>
        <name>Update Imagine Quote Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Customer Notes fix for Conga</fullName>
        <active>false</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set default text for Cover Sheet Comments</fullName>
        <actions>
            <name>Default_Text_of_Cover_Sheet_Comments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Cover_Sheet_Comments__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Contact</fullName>
        <actions>
            <name>Replace_with_Contact_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Replace_with_Contact_Fax</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Replace_with_Contact_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( ContactId ),NOT(ISNULL(ContactId)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Imagine Quote Number</fullName>
        <actions>
            <name>Update_Imagine_Quote_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISBLANK(Imagine_Quote_Number__c)
||
/* either does not have version or has wrong version */
NOT(CONTAINS(Imagine_Quote_Number__c, 
&quot;-V&quot;&amp;TEXT(Quote_Version__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WF_QuoteExpirationDate</fullName>
        <actions>
            <name>UpdateExpirationDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Default the quote expiration date to creation date plus 30 days. The User should be able to manually override this date.</description>
        <formula>ISBLANK(ExpirationDate)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
