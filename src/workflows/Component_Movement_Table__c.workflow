<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_for_Short_Receipt</fullName>
        <ccEmails>pupreti@su-kam.com,vimal.gupta@su-kam.com</ccEmails>
        <description>Email Notification for Short Receipt</description>
        <protected>false</protected>
        <recipients>
            <recipient>admin@companyskill.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ho.reports@su-kam.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>servicecrm@su-kamcompanyskill.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Short_Reciept_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>InwardLayoutLock</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Inward_Movement_Lock</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Inward Layout Lock</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Is_Created</fullName>
        <field>Is_Created__c</field>
        <literalValue>1</literalValue>
        <name>Is Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lock_Stock_Inward</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Stock_Received</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lock Stock Inward</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OutwardLayoutLock</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Outward_Lock</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Outward Layout Lock</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateReceivedRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Stock_Received</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Received Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateTransferStatus</fullName>
        <field>Stock_Transfer_Status__c</field>
        <literalValue>In Transit</literalValue>
        <name>Update Transfer Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <description>Update Record Type to Auto Inward</description>
        <field>RecordTypeId</field>
        <lookupValue>Stock_Inward</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatetheReceivedDate</fullName>
        <field>Received_Date__c</field>
        <formula>Today()</formula>
        <name>Update the Received Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UserAddress</fullName>
        <field>UserAddress__c</field>
        <formula>$User.City + &apos; &apos; +  $User.Branch_State__c</formula>
        <name>UserAddress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AutoInward Movement</fullName>
        <actions>
            <name>UpdateTransferStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Component_Movement_Table__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outward Movement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Component_Movement_Table__c.Type_of_Transfer__c</field>
            <operation>equals</operation>
            <value>Stock Transfer</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AutoInward Movement Received</fullName>
        <actions>
            <name>UpdateReceivedRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdatetheReceivedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Component_Movement_Table__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Stock Inward</value>
        </criteriaItems>
        <criteriaItems>
            <field>Component_Movement_Table__c.Type_of_Transfer__c</field>
            <operation>equals</operation>
            <value>Stock Transfer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Component_Movement_Table__c.Stock_Transfer_Status__c</field>
            <operation>equals</operation>
            <value>Received</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CMT Record Created</fullName>
        <actions>
            <name>Is_Created</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Component_Movement_Table__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Inward Lock</fullName>
        <actions>
            <name>InwardLayoutLock</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Component_Movement_Table__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inward Movement</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Outward Lock</fullName>
        <actions>
            <name>OutwardLayoutLock</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Component_Movement_Table__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outward Movement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Component_Movement_Table__c.Type_of_Transfer__c</field>
            <operation>equals</operation>
            <value>Transferred to Service Engineer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Short Receipt Email Notification</fullName>
        <actions>
            <name>Email_Notification_for_Short_Receipt</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Component_Movement_Table__c.Stock_Transfer_Status__c</field>
            <operation>equals</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>Component_Movement_Table__c.Short_Receipt_Quantity1__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Component_Movement_Table__c.Short_Receipt_Quantity2__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Component_Movement_Table__c.Short_Receipt_Quantity3__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Component_Movement_Table__c.Short_Receipt_Quantity4__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>Short Receipt Email Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Stock Inward Lock</fullName>
        <actions>
            <name>Lock_Stock_Inward</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Component_Movement_Table__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Stock Inward</value>
        </criteriaItems>
        <criteriaItems>
            <field>Component_Movement_Table__c.Stock_Transfer_Status__c</field>
            <operation>equals</operation>
            <value>Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Service Center</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UserAddress</fullName>
        <actions>
            <name>UserAddress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Component_Movement_Table__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>test123</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Component_Movement_Table__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
