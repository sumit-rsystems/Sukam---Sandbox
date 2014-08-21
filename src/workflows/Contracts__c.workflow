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
    <fieldUpdates>
        <fullName>Change_Record_Type_on_Contract</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Active_Contracts_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type on Contract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_Inactivate</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Inactive_Contract_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to Inactivate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChangetheContractsRecordType</fullName>
        <description>Change the Contracts Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>Active_Contracts_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change the Contracts Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>2nd AMC Payment Due Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contracts__c.Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contracts__c.Payment_Option__c</field>
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
            <field>Contracts__c.Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contracts__c.Payment_Option__c</field>
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
            <field>Contracts__c.Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contracts__c.Payment_Option__c</field>
            <operation>equals</operation>
            <value>Quarterly Payment</value>
        </criteriaItems>
        <description>This is an email notification about the 4th AMC Payment Due Instalments</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change Layout of Activated AMC Contracts</fullName>
        <actions>
            <name>ChangetheContractsRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Contracts__c.Status__c</field>
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
        <fullName>Change Record Type on Contract</fullName>
        <actions>
            <name>Change_Record_Type_on_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contracts__c.Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Comprehensive Check Up Due</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contracts__c.Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contracts__c.AMC_Type__c</field>
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
        <active>true</active>
        <criteriaItems>
            <field>Contracts__c.Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Expiry Notice</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contracts__c.Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <description>Contract Expiry Notice</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Not Closed</fullName>
        <actions>
            <name>Change_Record_Type_to_Inactivate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contracts__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Activated</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Non Comprehensive Check Up Due</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contracts__c.Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contracts__c.AMC_Type__c</field>
            <operation>equals</operation>
            <value>Non-Comprehensive</value>
        </criteriaItems>
        <description>Non Comprehensive Check Up Due</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
