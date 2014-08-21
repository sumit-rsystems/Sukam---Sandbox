<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Price_Book_Upload_ID</fullName>
        <field>Price_Book_Upload_ID__c</field>
        <formula>ERP_Code__c + TEXT ( Price_Book_Name__c )</formula>
        <name>Update Price Book Upload ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Updating the Price Book Upload Id field</fullName>
        <actions>
            <name>Update_Price_Book_Upload_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Price_Book__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
