<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Inform_user_about_FOC_Rejection</fullName>
        <description>Email: Inform user about FOC Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/FOCRequestRejectedCaseId</template>
    </alerts>
    <alerts>
        <fullName>Email_Inform_user_about_the_Component_Replacement_Approval</fullName>
        <description>Email: Inform user about the Component Replacement Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/ComponentReplacementRequestApprovedCaseId</template>
    </alerts>
    <alerts>
        <fullName>Email_Inform_user_about_the_Component_Replacement_Approval1</fullName>
        <description>Email: Inform user about the Component Replacement Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/ComponentReplacementRequestApprovedCaseId</template>
    </alerts>
    <alerts>
        <fullName>Email_Inform_user_about_the_Component_Replacement_Rejected</fullName>
        <description>Email: Inform user about the Component Replacement Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/ComponentReplacementRequestRejectedCaseId</template>
    </alerts>
    <alerts>
        <fullName>Email_Inform_user_about_the_FOC_Approval</fullName>
        <description>Email: Inform user about the FOC Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/FOCRequestApprovedCaseId</template>
    </alerts>
    <alerts>
        <fullName>Email_Inform_user_about_the_FOC_Approval1</fullName>
        <description>Email: Inform user about the FOC Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/FOCRequestApprovedCaseId</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_be_sent_if_Service_Request_Category_equals_Battery_Blast</fullName>
        <ccEmails>mkotnala@su-kam.com,sdahiya@su-kam.com,gsachdev@su-kam.com,jbisht@su-kam.com,sukamadmin@gmail.com</ccEmails>
        <description>Mail to be sent if Service Request Category equals Battery Blast</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Mail_to_be_sent_for_every_Service_Request_Category</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_be_sent_if_Service_Request_Category_equals_Battery_bulging</fullName>
        <ccEmails>mkotnala@su-kam.com,sdahiya@su-kam.com,gsachdev@su-kam.com,jbisht@su-kam.com,sukamadmin@gmail.com</ccEmails>
        <description>Mail to be sent if Service Request Category equals Battery bulging</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Mail_to_be_sent_for_every_Service_Request_Category</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_be_sent_if_Service_Request_Category_equals_Battery_smells_high_fume_rele</fullName>
        <ccEmails>mkotnala@su-kam.com,sdahiya@su-kam.com,gsachdev@su-kam.com,jbisht@su-kam.com,sukamadmin@gmail.com</ccEmails>
        <description>Mail to be sent if Service Request Category equals Battery smells(high fume release)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Mail_to_be_sent_for_every_Service_Request_Category</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_be_sent_if_Service_Request_Category_equals_Shock_problem_in_inverter</fullName>
        <ccEmails>mkotnala@su-kam.com,sdahiya@su-kam.com,gsachdev@su-kam.com,jbisht@su-kam.com,sukamadmin@gmail.com</ccEmails>
        <description>Mail to be sent if Service Request Category equals Shock problem in inverter</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Mail_to_be_sent_for_every_Service_Request_Category</template>
    </alerts>
    <alerts>
        <fullName>Service_Request_Owner_Has_been_Changed</fullName>
        <description>Service Request Owner Has been Changed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Service_Request_Transferred_New</template>
    </alerts>
    <fieldUpdates>
        <fullName>ApprovedDisaaprovedStatus</fullName>
        <field>Status__c</field>
        <literalValue>Approved / Disapproved</literalValue>
        <name>Approved / Disaaproved Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Approval_Status_Picklist</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Change Approval Status Picklist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_RecordTypeToDefault</fullName>
        <field>RecordTypeId</field>
        <lookupValue>New_Service_Request</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RecordTypeToDefault</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_RecordType_to_New</fullName>
        <field>RecordTypeId</field>
        <lookupValue>New_Service_Request</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RecordType to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_on_Service_Request</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Service_Request_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type on Service Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CheckCaseClose</fullName>
        <field>Close_Case__c</field>
        <literalValue>1</literalValue>
        <name>Check Case Close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OnHoldStatus</fullName>
        <field>Status__c</field>
        <literalValue>Approval On Hold</literalValue>
        <name>On Hold Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProductCategory</fullName>
        <field>Product_Category__c</field>
        <name>ProductCategory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Approved_Disapproved</fullName>
        <field>Status__c</field>
        <literalValue>Approval On Hold</literalValue>
        <name>Status - Approved / Disapproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Approved_Disapproved1</fullName>
        <field>Status__c</field>
        <literalValue>Approved / Disapproved</literalValue>
        <name>Status - Approved / Disapproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Approved_Disapproved2</fullName>
        <field>Status__c</field>
        <literalValue>Approved / Disapproved</literalValue>
        <name>Status - Approved / Disapproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_On_Hold</fullName>
        <field>Status__c</field>
        <literalValue>On Hold</literalValue>
        <name>Status - On Hold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_Request_Status_field</fullName>
        <description>Update Service Request Status field</description>
        <field>Status__c</field>
        <literalValue>Assigned</literalValue>
        <name>Update Service Request Status field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AR Invoice Case</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4 OR 5 OR 6 )</booleanFilter>
        <criteriaItems>
            <field>Service_Request__c.Receiving_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Service_Request__c.SFFLAG__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Service_Request__c.Service_Charges__c</field>
            <operation>equals</operation>
            <value>,INR 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Service_Request__c.Service_Charges_Other__c</field>
            <operation>equals</operation>
            <value>,INR 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Service_Request__c.Component_Charges__c</field>
            <operation>equals</operation>
            <value>,INR 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Service_Request__c.Other_Expenses__c</field>
            <operation>equals</operation>
            <value>,INR 0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email to be sent if the Service Request or Case Category is Battery Blast</fullName>
        <actions>
            <name>Mail_to_be_sent_if_Service_Request_Category_equals_Battery_Blast</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Category__c</field>
            <operation>equals</operation>
            <value>Battery Blast</value>
        </criteriaItems>
        <description>Email alerts to be sent based on whether the case category is Battery Blast</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email to be sent if the Service Request or Case Category is Battery bulging</fullName>
        <actions>
            <name>Mail_to_be_sent_if_Service_Request_Category_equals_Battery_bulging</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Category__c</field>
            <operation>equals</operation>
            <value>Battery Bulging</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email to be sent if the Service Request or Case Category is Battery smells%28high fume release%29</fullName>
        <actions>
            <name>Mail_to_be_sent_if_Service_Request_Category_equals_Battery_smells_high_fume_rele</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Category__c</field>
            <operation>equals</operation>
            <value>Battery smells(high fume release)</value>
        </criteriaItems>
        <description>Email alerts to be sent based on whether the case category is Battery smells(high fume release)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email to be sent if the Service Request or Case Category is Burn Smell</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Category__c</field>
            <operation>equals</operation>
            <value>Burn Smell</value>
        </criteriaItems>
        <description>Email alerts to be sent based on whether the case category is Burn Smell</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email to be sent if the Service Request or Case Category is Shock problem in inverter</fullName>
        <actions>
            <name>Mail_to_be_sent_if_Service_Request_Category_equals_Shock_problem_in_inverter</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Category__c</field>
            <operation>equals</operation>
            <value>Shock problem in inverter</value>
        </criteriaItems>
        <description>Email alerts to be sent based on whether the case category is Shock problem in inverter</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Service request Transferred</fullName>
        <actions>
            <name>Service_Request_Owner_Has_been_Changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>On Hold Status Rule</fullName>
        <actions>
            <name>OnHoldStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Service_Engineer_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Service_Request__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>On Hold Status Rule</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SR Not Closed</fullName>
        <actions>
            <name>Change_RecordType_to_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service Request Closed</fullName>
        <actions>
            <name>Change_Record_Type_on_Service_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status update for Approved %2F Disapproved Requests</fullName>
        <actions>
            <name>ApprovedDisaaprovedStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Action Taken</value>
        </criteriaItems>
        <description>Status update for Approved / Disapproved Requests</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Uneditable Closed Case</fullName>
        <actions>
            <name>CheckCaseClose</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>This workflow will help us update a hidden field, when status of Case is &quot;Closed&quot;.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Validation rule for Assigned cases</fullName>
        <actions>
            <name>Change_RecordTypeToDefault</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Service_Request_Status_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Service_Request__c.Service_Engineer_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Validation rule for Assigned Cases</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
