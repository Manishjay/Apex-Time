public with sharing class CaseTriggerHandler {

    public static void assignContactAndScheduleFollowUp(List<Case> casesWithoutContact) {
        Set<Id> accountIdsToQuery = new Set<Id>(); 
        Map<Id, Contact> accountContactMap = new Map<Id, Contact>(); 
        List<Event> followUpEvents = new List<Event>(); 

        // AccId for cases without Contact
        for (Case caseRecord : casesWithoutContact) {
            if (caseRecord.AccountId != null && caseRecord.ContactId == null) {
                accountIdsToQuery.add(caseRecord.AccountId);
            }
        }

        // Most recent Primary Level contacts
        if (!accountIdsToQuery.isEmpty()) {
            List<Contact> primaryContacts = [
                SELECT Id, AccountId, Level__c
                FROM Contact
                WHERE AccountId IN :accountIdsToQuery AND Level__c = 'Primary'
                ORDER BY LastModifiedDate DESC
            ];
            
            // Map of AccId with Contact 
            for (Contact contact : primaryContacts) {
                accountContactMap.put(contact.AccountId, contact);
            }
        }

        // Contact assignment
        for (Case caseRecord : casesWithoutContact) {
            if (caseRecord.AccountId != null && caseRecord.ContactId == null && accountContactMap.containsKey(caseRecord.AccountId)) {
                Contact assignedContact = accountContactMap.get(caseRecord.AccountId);
                caseRecord.ContactId = assignedContact.Id; 

                // Follow up Events 
                Datetime eventStartDate = Datetime.now().addDays(3);
                Datetime eventEndDate = eventStartDate.addHours(3);

                Event followUpEvent = new Event();
                followUpEvent.Subject = caseRecord.Subject +'on: '+caseRecord.caseNumber;
                followUpEvent.WhoId = assignedContact.Id; 
                followUpEvent.WhatId = caseRecord.Id; 
                followUpEvent.StartDateTime = eventStartDate;
                followUpEvent.EndDateTime = eventEndDate;
                
                followUpEvents.add(followUpEvent); 

            } 
            
            else if (caseRecord.ContactId == null) {
                // Error Message if no primary contact found
                caseRecord.addError('No primary-level contact found for the associated account.');
            }
        }

        // Events Insertions
        if (!followUpEvents.isEmpty()) {
            insert followUpEvents;
        }
    }
    
}