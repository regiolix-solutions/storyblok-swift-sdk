//
//  Storyblokself.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public class StoryblokQuery: NSObject{
    var startsWith: String?
    var byUUIDs: [UUID]?
    var bySlugs: [String]?
    var excludingSlugs: [String]?
    var byUUIDsOrdered: [UUID]?
    var excludingIds: [Int64]?
    var excludingFields: [String]?
    var inWorkflowStages: String?
    var searchTerm: String?
    var firstPublishedAtGt: Date?
    var firstPublishedAtLt: Date?
    var publishedAtGt: Date?
    var publishedAtLt: Date?
    var isStartPage: Bool?
    var page: Int?
    var perPage: Int?
    var version: StoryVersion?
    var resolveLinks: ResolveLinks?
    var resolveRelations: String?
    var fromRelease: String?
    var cv: String?
    var language: String?
    var fallbackLang: String?
    var filterQueryParameters: Set<FilterQueryParameter>?
    var resolveAssets: Int? //0 = doesn't resolve assets, 1 = resolves assets | Only available with premium plans
    var sortBy: String?
    var contentType: String?
    var folderLevel: Int?
    var withTag: String?
    
    fileprivate override init() {}
    
    public override var description: String {
        var dynamicDescription: String = ""
        
        if let startsWith = startsWith {
            dynamicDescription.append(contentsOf: "&starts_with=\(startsWith)")
        }
        
        if let byUUIDs = byUUIDs {
            dynamicDescription.append(contentsOf: "&by_uuids=\(byUUIDs)")
        }
        
        if let bySlugs = bySlugs {
            dynamicDescription.append(contentsOf: "&by_slugs=\(bySlugs)")
        }
        
        if let excludingSlugs = excludingSlugs {
            dynamicDescription.append(contentsOf: "&excluding_slugs=\(excludingSlugs)")
        }
        
        if let byUUIDsOrdered = byUUIDsOrdered {
            dynamicDescription.append(contentsOf: "&by_uuids_ordered=\(byUUIDsOrdered)")
        }
        
        if let excludingIds = excludingIds {
            dynamicDescription.append(contentsOf: "&excluding_ids=\(excludingIds)")
        }
        
        if let excludingFields = excludingFields {
            dynamicDescription.append(contentsOf: "&excluding_fields=\(excludingFields)")
        }
        
        if let inWorkflowStages = inWorkflowStages {
            dynamicDescription.append(contentsOf: "&in_workflow_stages=\(inWorkflowStages)")
        }
        
        if let searchTerm = searchTerm {
            dynamicDescription.append(contentsOf: "&search_term=\(searchTerm)")
        }
        
        if let firstPublishedAtGt = firstPublishedAtGt {
            dynamicDescription.append(contentsOf: "&first_published_at_gt=\(firstPublishedAtGt)")
        }
        
        if let firstPublishedAtLt = firstPublishedAtLt {
            dynamicDescription.append(contentsOf: "&first_published_at_lt=\(firstPublishedAtLt)")
        }
        
        if let publishedAtGt = publishedAtGt {
            dynamicDescription.append(contentsOf: "&published_at_gt=\(publishedAtGt)")
        }
        
        if let publishedAtLt = publishedAtLt {
            dynamicDescription.append(contentsOf: "&published_at_lt=\(publishedAtLt)")
        }
        
        if let isStartPage = isStartPage {
            dynamicDescription.append(contentsOf: "&is_startpage=\(isStartPage)")
        }
        
        if let page = page {
            dynamicDescription.append(contentsOf: "&page=\(page)")
        }
        
        if let perPage = perPage {
            dynamicDescription.append(contentsOf: "&per_page=\(perPage)")
        }
        
        if let version = version {
            dynamicDescription.append(contentsOf: "&version=\(version)")
        }
        
        if let resolveLinks = resolveLinks {
            dynamicDescription.append(contentsOf: "&resolve_links=\(resolveLinks)")
        }
        
        if let resolveRelations = resolveRelations {
            dynamicDescription.append(contentsOf: "&resolve_relations=\(resolveRelations)")
        }
        
        if let fromRelease = fromRelease {
            dynamicDescription.append(contentsOf: "&from_release=\(fromRelease)")
        }
        
        if let cv = cv {
            dynamicDescription.append(contentsOf: "&cv=\(cv)")
        }
        
        if let language = language {
            dynamicDescription.append(contentsOf: "&language=\(language)")
        }
        
        if let fallbackLang = fallbackLang {
            dynamicDescription.append(contentsOf: "&fallback_lang=\(fallbackLang)")
        }
        
        if let resolveAssets = resolveAssets {
            dynamicDescription.append(contentsOf: "&resolve_assets=\(resolveAssets)")
        }
        
        if let sortBy = sortBy {
            dynamicDescription.append(contentsOf: "&sort_by=\(sortBy)")
        }
        
        if let filterQueryParameters = filterQueryParameters {
            filterQueryParameters.forEach {
                dynamicDescription.append(contentsOf: "&\($0.description)")
            }
        }
        
        if let contentType = contentType {
            dynamicDescription.append(contentsOf: "&content_type=\(contentType)")
        }
        
        
        if let folderLevel = folderLevel {
            dynamicDescription.append(contentsOf: "&level=\(folderLevel)")
        }
        
        if let withTag = withTag {
            dynamicDescription.append(contentsOf: "&with_tag=\(withTag)")
        }
        
        return dynamicDescription
    }
    
    //MARK: Builder Functions
    
    /// Filter by full_slug. Can be used to retrieve all entries form a specific folder.
    /// Examples: de/beitraege, en/posts.
    /// Attention: If you use field level translations and a root folder with the same name of a language code you need to prepend [default] to the path to retrieve the default language (Example: starts_with=[default]/de/home).
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/stories}
    public func startingWith(_ startsWith: String) -> Self{
        self.startsWith = startsWith
        return self
    }
    
    /// Add fields to exclude from your content object
    public func excludingFields(_ excludingField: String) -> Self{
        if self.excludingFields == nil {
            self.excludingFields = []
        }
        excludingFields?.append(excludingField)
        return self
    }
    
    /// Add a cache version
    /// Read more at {https://www.storyblok.com/docs/api/content-delivery#topics/cache-invalidation}
    public func addingCacheVersion(_ cv: String) -> Self{
        self.cv = cv
        return self
    }
    
    /// The version of the story
    public func version(_ version: StoryVersion) -> Self{
        self.version = version
        return self
    }

    /// Add a filter query parameter to the query
    public func `where`(_ attribute: String, is filterOperation: FilterOperation, value: String) -> Self{
        return filteredByQueryParameter(FilterQueryParameter(whereAttribute: attribute, is: filterOperation, value: value))
    }

    /// Add a filter query parameter to the query
    public func filteredByQueryParameter(_ queryParameter: FilterQueryParameter) -> Self{
        if filterQueryParameters == nil {
            filterQueryParameters = Set()
        }
        filterQueryParameters?.update(with: queryParameter)
        return self
    }
    
    /// Resolve relationships to other Stories of a multi-option or single-option field-type.
    /// Provide the component name and the field key as comma separated string. The limit of resolved relationships is 100 Stories.
    /// See {https://www.storyblok.com/tp/using-relationship-resolving-to-include-other-content-entries}
    public func resolvingRelations(for resolveRelations: String) -> Self{
        self.resolveRelations = resolveRelations
        return self
    }
    
    /// The parameter resolve_links will automatically resolve internal links of the multilink field type.
    /// If the value is 'story' the whole story object will be included.
    /// If the value is 'url' only uuid, id, name, path, slug and url (url is a computed property which returns the "Real path" if defined to use it for navigation links) will be included.
    /// The limit of resolved links per Story is 50 when resolving with story and 100 when resolving with url.
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/retrieve-one-story}
    public func resolvingLinks(for resolveLinks: ResolveLinks) -> Self{
        self.resolveLinks = resolveLinks
        return self
    }
    
    /// Access version of specific release by release id
    public func fromRelease(_ fromRelease: String) -> Self{
        self.fromRelease = fromRelease
        return self
    }

    /// Add the language i18n code as query parameter to receive a localized version when using a numeric id or uuid as path parameter
    public func forLanguage(_ language: String) -> Self{
        self.language = language
        return self
    }

    /// Define a custom fallback language (i18n code). By default the fallback language is the one defined in the space settings
    public func withFallbackLanguage(being fallbackLang: String) -> Self{
        self.fallbackLang = fallbackLang
        return self
    }

}

public class StoryblokMultiStoryQuery: StoryblokQuery{
    /// Create a new Builder for multiple stories
    public static func queryForStories() -> StoryblokMultiStoryQuery{
        return StoryblokMultiStoryQuery()
    }
    
    /// Search content items by full text.
    public func matchingSearchTerm(_ searchTerm: String) -> Self{
        self.searchTerm = searchTerm
        return self
    }
    
    public func sortedBy(_ sortDescriptor: String) -> Self{
        self.sortBy = sortDescriptor
        return self
    }
    
    /// When retrieving multiple stories, the page which should be fetched can be set.
    /// See {https://www.storyblok.com/docs/api/content-delivery#topics/pagination}
    public func forPage(_ page: Int) -> Self{
        self.page = page
        return self
    }

    /// How many entries per page should be fetched.
    /// Default: 25. Max: 100
    public func withPageSize(of perPage: Int) -> Self{
        self.perPage = perPage
        return self
    }
    
    /// Get stories by full_slug's.
    /// You can also specify wildcards with *.
    /// Examples: authors/john, authors/max, authors/*,articles/*
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/stories}
    public func withSlug(_ slug: String) -> Self{
        if self.bySlugs == nil{
            self.bySlugs = []
        }
        self.bySlugs?.append(slug)
        return self
    }

    /// Exclude stories by full_slug's.
    /// You can also specify wildcards with *.
    /// Examples: authors/john, authors/max, authors/*,articles/*
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/stories}
    public func excludingSlug(_ slug: String) -> Self{
        if self.excludingSlugs == nil{
            self.excludingSlugs = []
        }
        self.excludingSlugs?.append(slug)
        return self
    }
    
    /// Comma separated list of ids. Example: in_workflow_stages=3,4
    public func inWorkflowStages(_ inWorkflowStages: String) -> Self{
        self.inWorkflowStages = inWorkflowStages
        return self
    }

    /// After a specific first published date (Format: 2018-03-03 10:00)
    public func firstPublishedAfter(_ firstPublishedAtGt: Date) -> Self{
        self.firstPublishedAtGt = firstPublishedAtGt
        return self
    }

    /// Before a specific first published date (Format: 2018-03-03 10:00)
    public func firstPublishedBefore(_ firstPublishedAtLt: Date) -> Self{
        self.firstPublishedAtLt = firstPublishedAtLt
        return self
    }

    /// After a specific published date (Format: 2018-03-03 10:00)
    public func publishedAfter(_ publishedAtGt: Date) -> Self{
        self.publishedAtGt = publishedAtGt
        return self
    }

    /// Before a specific published date (Format: 2018-03-03 10:00)
    public func publishedBefore(_ publishedAtLt: Date) -> Self{
        self.publishedAtLt = publishedAtLt
        return self
    }
    
    public func ofContentType(_ contentType: String) -> Self{
        self.contentType = contentType
        return self
    }
    
    public func atFolderLevel(_ folderLevel: Int) -> Self{
        self.folderLevel = folderLevel
        return self
    }
    
    /// Exclude stories with the id added
    public func excludingId(_ excludingId: Int64) -> Self{
        if self.excludingIds == nil {
            self.excludingIds = []
        }
        self.excludingIds?.append(excludingId)
        return self
    }
    
    /// Get stories by UUIDs.
    /// To get a specific language you need to combine this filter with starts_with=en/* (replace en with your langauge)
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/stories}
    public func withUUID(_ uuid: UUID) -> Self{
        if self.byUUIDs == nil{
            self.byUUIDs = []
        }
        self.byUUIDs?.append(uuid)
        return self
    }

    /// Get stories added uuid's ordered by the sequence provided
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/stories}
    public func WithAndOrderedByUUID(_ uuid: UUID) -> Self{
        if self.byUUIDsOrdered == nil {
            self.byUUIDsOrdered = []
        }
        self.byUUIDsOrdered?.append(uuid)
        return self
    }
    
    public func withTag(_ tag: String) -> Self{
        self.withTag = tag
        return self
    }
    
    /// Filter by folder startpage. Use {true} to only return startpages and {false} to exclude startpages from the result.
    public func thatAreStartPages(_ startPage: Bool) -> Self{
        self.isStartPage = startPage
        return self
    }
}

public class StoryblokSingleStoryQuery: StoryblokQuery{
    /// Create a new Builder for single stories
    public static func queryForStory() -> StoryblokSingleStoryQuery{
        return StoryblokSingleStoryQuery()
    }
}
