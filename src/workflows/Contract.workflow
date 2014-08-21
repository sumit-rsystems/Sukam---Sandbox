<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AMCChargeEmail</fullName>
        <ccEmails>apyadav@su-kam.com</ccEmails>
        <ccEmails>crm@su-kam.com</ccEmails>
        <description>AMC Charge Email</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/AMC_Amount_Details</template>
    </alerts>
    <alerts>
        <fullName>AMCPaymentNotification2ndpayment</fullName>
        <description>AMC Payment Notification (2nd payment)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AMC_Payment_Due</template>
    </alerts>
    <alerts>
        <fullName>EmailalertforexpiryofContract</fullName>
        <description>Email alert for expiry of Contract</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contract_Renewal_Alert</template>
    </alerts>
    <alerts>
        <fullName>x1stCheckUpDue</fullName>
        <description>1st Check Up Due</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Check_up_Due</template>
    </alerts>
    <alerts>
        <fullName>x1stNonComprehensiveAMCCheckUpDue</fullName>
        <description>1st Non Comprehensive AMC Check Up Due</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Check_up_Due</template>
    </alerts>
    <alerts>
        <fullName>x2ndCheckUpDue</fullName>
        <ccEmails>bharadwajsaurav@gmail.com</ccEmails>
        <description>2nd Check Up Due</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Check_up_Due</template>
    </alerts>
    <alerts>
        <fullName>x2ndNonComprehensiveAMCCheckUpDue</fullName>
        <description>2nd Non Comprehensive AMC Check Up Due</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Check_up_Due</template>
    </alerts>
    <alerts>
        <fullName>x3rdAMCInstalmentPaymentNotification</fullName>
        <description>3rd AMC Instalment Payment Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AMC_Payment_Due_3</template>
    </alerts>
    <alerts>
        <fullName>x3rdCheckUpDue</fullName>
        <description>3rd Check Up Due</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Check_up_Due</template>
    </alerts>
    <alerts>
        <fullName>x4thAMCINstalmentpaymentAlert</fullName>
        <description>4th AMC INstalment payment Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AMC_Payment_Due_4</template>
    </alerts>
    <alerts>
        <fullName>x4thCheckUpDue</fullName>
        <description>4th Check Up Due</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Check_up_Due</template>
    </alerts>
    <fieldUpdates>
        <fullName>ChangetheContractRecordType</fullName>
        <description>Change the Contract Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>Active_Contracts_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change the Contract Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>2nd AMC Payment Due Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Payment_Option__c</field>
            <operation>notEqual</operation>
            <value>Single Advance Payment</value>
        </criteriaItems>
        <description>This is an email notification about the 2nd AMC Payment Due Instalments</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>3rd AMC Payment Due Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Payment_Option__c</field>
            <operation>equals</operation>
            <value>Quarterly Payment</value>
        </criteriaItems>
        <description>This is an email notification about the 3rdAMC Payment Due Instalments</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>4th AMC Payment Due Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Payment_Option__c</field>
            <operation>equals</operation>
            <value>Quarterly Payment</value>
        </criteriaItems>
        <description>This is an email notification about the 4th AMC Payment Due Instalments</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change Layout of Activated AMC Contracts</fullName>
        <actions>
            <name>ChangetheContractRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>System Administrator</value>
        </criteriaItems>
        <description>Change Layout of Activated AMC Contracts</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Comprehensive Check Up Due</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.AMC_Type__c</field>
            <operation>equals</operation>
            <value>Comprehensive</value>
        </criteriaItems>
        <description>Comprehensive Check Up Due</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Amount Details</fullName>
        <actions>
            <name>AMCChargeEmail</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Expiry Notice</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <description>Contract Expiry Notice</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Non Comprehensive Check Up Due</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.AMC_Type__c</field>
            <operation>equals</operation>
            <value>Non-Comprehensive</value>
        </criteriaItems>
        <description>Non Comprehensive Check Up Due</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
