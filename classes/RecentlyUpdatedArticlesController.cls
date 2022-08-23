public with sharing class RecentlyUpdatedArticlesController {
    @AuraEnabled
    public static List<KnowledgeArticleVersion> getArticlesList(){
		final String PUBLISH_STATUS_ONLINE = 'Online'; 
        final String LANGUAGE = 'en_US'; 
        
		final String q = 'SELECT Title, UrlName, Id, LastPublishedDate FROM KnowledgeArticleVersion WHERE PublishStatus = :PUBLISH_STATUS_ONLINE AND Language = :LANGUAGE ORDER BY LastPublishedDate DESC LIMIT 5';
		List<KnowledgeArticleVersion> articles = Database.query(q);

        return articles;
    }
}