@isTest
class RecentlyUpdatedArticlesTest {
    static testMethod void test() {
       List<KnowledgeArticleVersion> kavList = RecentlyUpdatedArticlesController.getArticlesList();
       System.assert(kavlist !=null);
    }

}