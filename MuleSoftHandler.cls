@RestResource(urlMapping='/MuleSoft/*')  
global with sharing class MuleSoftHandler {  
    
    @HttpPost  
    global static String callEmail( String msgbody, String subject ) {  
      
        system.debug( 'Inside the callEmail' );  
      
        try {  
  
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();       
            mail.setTargetObjectId( UserInfo.getUserId() );         
            mail.setSaveAsActivity( false );  
            mail.setSubject( 'Important: ' + subject );            
            mail.setHtmlBody( 'From MuleSoft<br/>' + msgbody );          
            Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );           
            return 'Email Sent successfully';  
              
        } catch( Exception e ) {  
          
            return e.getMessage();  
              
        }  
          
    }  
      
}  
