<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>displayapprovaldate</fullName>
        <field>Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Display Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updaterequisitiondate</fullName>
        <field>Requisition_Date__c</field>
        <formula>CreatedDate</formula>
        <name>Update Requisition Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Display Approval Date</fullName>
        <actions>
            <name>displayapprovaldate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Indent_Request__c.Indent_Request_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Indent_Request__c.Approval_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Requisition Date</fullName>
        <actions>
            <name>updaterequisitiondate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Rule to update the requisition date with the created date</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
