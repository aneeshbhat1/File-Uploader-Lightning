/**
 * Created by Archana on 28-06-2017.
 */

public with sharing class FileUploadController {
    @AuraEnabled
    public static Boolean upload(String fileName, String content) {
        try {
            ContentVersion v = new ContentVersion();
            v.versionData = EncodingUtil.base64Decode(content);
            v.title = fileName;
            v.pathOnClient = fileName;
            insert v;
            //ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), 'Me', ConnectApi.FeedElementType.FeedItem, 'On vacation this week.');
            // Define the FeedItemInput object to pass to postFeedElement
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            User user = [SELECT Id,Name FROM User WHERE Name LIKE '%Arjun%' LIMIT 1];
            feedItemInput.subjectId = user.Id;


            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            textSegmentInput.text = 'A new template is loaded!';

            // The MessageBodyInput object holds the text in the post
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            messageBodyInput.messageSegments.add(textSegmentInput);
            feedItemInput.body = messageBodyInput;

            // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
            // For this feed item, we define a files capability to hold the file(s).
            List<String> fileIds = new List<String>();
            ContentDocument doc = [SELECT Id,LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId=:v.Id LIMIT 1];
            fileIds.add(doc.Id);

            ConnectApi.FilesCapabilityInput filesInput = new ConnectApi.FilesCapabilityInput();
            filesInput.items = new List<ConnectApi.FileIdInput>();

            for (String fileId : fileIds) {
                ConnectApi.FileIdInput idInput = new ConnectApi.FileIdInput();
                idInput.id = fileId;
                filesInput.items.add(idInput);
            }

            ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
            feedElementCapabilitiesInput.files = filesInput;

            feedItemInput.capabilities = feedElementCapabilitiesInput;

            // Post the feed item.
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

            return true;
        } catch (Exception e) {
            return false;
        }
    }
}