global class ContactAccountUrl 
{
    WebService static String getURL(String phone,String serverurl) 
    {
        System.debug('@@@@@@@@@@@@@@ start contactaccounturl @@@@@@@@@@@');
		System.debug('start time : '+datetime.now());
		If(phone.length()>9)
		{
			String phone1=phone;//'('+phone.substring(0,3)+') '+phone.substring(3,6)+'-'+phone.substring(6,10);
			Id acct=null;
			Id cont=null;
			List<Id> contactids= new List<Id>();
			String sessionid=UserInfo.getSessionId();
			String url='';
			String returnurl='';
			String[] str=serverurl.split('/');
			String servurl='https://emea.salesforce.com';//(str.get(0)+'//'+str.get(2)).replace('-api','');
			
			url=servurl+'/secur/frontdoor.jsp?sid='+sessionid+'&retURL=';
			/*
			serverurl=https://na2-api.salesforce.com/services/Soap/u/12.0/4c1300D4000000078xH

			//search/SearchResults?searchType=1%26sen=0%26setLast=1%26sbstr=12345678
			///setup/ui/recordtypeselect.jsp?ent=Account
			str=this.SERVER.split('/');
			con=str[0]+"//"+str[2];
			serverurl=con.replace("-api","");
			returnurl=serverurl+"/"+obj._whatid;
			url=serverurl+"/secur/frontdoor.jsp?sid="+obj.sessionId+"&retURL="+returnurl;
			window.open(url);
			*/
			for(Contact con:[Select id from Contact where Phone=:phone1 or OtherPhone=:phone1 or MobilePhone=:phone1 or homephone=:phone1 or Phone=:phone or OtherPhone=:phone or MobilePhone=:phone or homephone=:phone])
			{
				contactids.add(con.Id);
			}
			if(contactids.size()>1)
			{
				//search page
				returnurl=servurl+'/search/SearchResults?searchType=1%26sen=0%26setLast=1%26sbstr='+phone;
				url=returnurl;
			}
			else{

				//cont=contactids.get(0);
				if(contactids.size()==0){
				//for(Account acc:[Select id from Account where Phone=:phone])
				for(Account acc:[Select id from Account where Phone=:phone1 or Mobile_No__c=:phone1 or Alternate_Phone_No__c=:phone1 or Phone=:phone or Mobile_No__c=:phone or Alternate_Phone_No__c=:phone])
				{
					acct=acc.Id;
				}
				if(acct==null){
					//new page
					//001/e
					returnurl=servurl+'/setup/ui/recordtypeselect.jsp?ent=Account&save_new_url=%2F001%2Fe%3F';
					url=returnurl;
				}
				else{
					//acct page
					returnurl=servurl+'/'+acct;
					url=returnurl;
				}
				}
				else{
				//contpage
				cont=contactids.get(0);
				returnurl=servurl+'/'+cont;
				url=returnurl;
				}
			}
			System.debug('end time : '+datetime.now());
			System.debug('@@@@@@@@@@@@@@ end contactaccounturl @@@@@@@@@@@');
			return url;
		}
		else{
			System.debug('end time : '+datetime.now());
			System.debug('@@@@@@@@@@@@@@ end contactaccounturl @@@@@@@@@@@');
			return null;
		}
    }
}