//
//  StoryblokQueryBuilder.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

class StoryblokQueryBuilder{
    fileprivate let query = StoryblokQuery()
    
    fileprivate init() {}

    /// Filter by full_slug. Can be used to retrieve all entries form a specific folder.
    /// Examples: de/beitraege, en/posts.
    /// Attention: If you use field level translations and a root folder with the same name of a language code you need to prepend [default] to the path to retrieve the default language (Example: starts_with=[default]/de/home).
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/stories}
    func startingWith(_ startsWith: String) -> Self{
        query.startsWith = startsWith
        return self
    }
    
    /// Add fields to exclude from your content object
    func excludingFields(_ excludingField: String) -> Self{
        if query.excludingFields == nil {
            query.excludingFields = []
        }
        query.excludingFields?.append(excludingField)
        return self
    }
    
    /// Add a cache version
    /// Read more at {https://www.storyblok.com/docs/api/content-delivery#topics/cache-invalidation}
    func addingCacheVersion(_ cv: String) -> Self{
        query.cv = cv
        return self
    }
    
    /// The version of the story
    func version(_ version: StoryVersion) -> Self{
        query.version = version
        return self
    }

    /// Add a filter query parameter to the query
    func `where`(_ attribute: String, is filterOperation: FilterOperation, value: String) -> Self{
        return filteredByQueryParameter(FilterQueryParameter(whereAttribute: attribute, is: filterOperation, value: value))
    }

    /// Add a filter query parameter to the query
    func filteredByQueryParameter(_ queryParameter: FilterQueryParameter) -> Self{
        if query.filterQueryParameters == nil {
            query.filterQueryParameters = Set()
        }
        query.filterQueryParameters?.update(with: queryParameter)
        return self
    }
    
    /// Resolve relationships to other Stories of a multi-option or single-option field-type.
    /// Provide the component name and the field key as comma separated string. The limit of resolved relationships is 100 Stories.
    /// See {https://www.storyblok.com/tp/using-relationship-resolving-to-include-other-content-entries}
    func resolvingRelations(for resolveRelations: String) -> Self{
        query.resolveRelations = resolveRelations
        return self
    }
    
    /// The parameter resolve_links will automatically resolve internal links of the multilink field type.
    /// If the value is 'story' the whole story object will be included.
    /// If the value is 'url' only uuid, id, name, path, slug and url (url is a computed property which returns the "Real path" if defined to use it for navigation links) will be included.
    /// The limit of resolved links per Story is 50 when resolving with story and 100 when resolving with url.
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/retrieve-one-story}
    func resolvingLinks(for resolveLinks: ResolveLinks) -> Self{
        query.resolveLinks = resolveLinks
        return self
    }
    
    /// Access version of specific release by release id
    func fromRelease(_ fromRelease: String) -> Self{
        query.fromRelease = fromRelease
        return self
    }

    /// Add the language i18n code as query parameter to receive a localized version when using a numeric id or uuid as path parameter
    func forLanguage(_ language: String) -> Self{
        query.language = language
        return self
    }

    /// Define a custom fallback language (i18n code). By default the fallback language is the one defined in the space settings
    func withFallbackLanguage(being fallbackLang: String) -> Self{
        query.fallbackLang = fallbackLang
        return self
    }
}

class StoryblokStoryQueryBuilder: StoryblokQueryBuilder{
    
    fileprivate override init() {}
    
    /// Added if you want to query by uuid instead of using the numeric id
    private func findBy(_ findBy: String) -> Self{
        query.findBy = findBy
        return self
    }
    
    
}

class StoryblokStoriesQueryBuilder: StoryblokQueryBuilder{
    
    fileprivate override init() {}
    
    /// Search content items by full text.
    func matchingSearchTerm(_ searchTerm: String) -> Self{
        query.searchTerm = searchTerm
        return self
    }
    
    func sortedBy(_ sortDescriptor: String) -> Self{
        query.sortBy = sortDescriptor
        return self
    }
    
    /// When retrieving multiple stories, the page which should be fetched can be set.
    /// See {https://www.storyblok.com/docs/api/content-delivery#topics/pagination}
    func forPage(_ page: Int) -> Self{
        query.page = page
        return self
    }

    /// How many entries per page should be fetched.
    /// Default: 25. Max: 100
    func withPageSize(of perPage: Int) -> Self{
        query.perPage = perPage
        return self
    }
    
    /// Get stories by full_slug's.
    /// You can also specify wildcards with *.
    /// Examples: authors/john, authors/max, authors/*,articles/*
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/stories}
    func withSlug(_ slug: String) -> Self{
        if query.bySlugs == nil{
            query.bySlugs = []
        }
        query.bySlugs?.append(slug)
        return self
    }

    /// Exclude stories by full_slug's.
    /// You can also specify wildcards with *.
    /// Examples: authors/john, authors/max, authors/*,articles/*
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/stories}
    func excludingSlug(_ slug: String) -> Self{
        if query.excludingSlugs == nil{
            query.excludingSlugs = []
        }
        query.excludingSlugs?.append(slug)
        return self
    }
    
    /// Comma separated list of ids. Example: in_workflow_stages=3,4
    func inWorkflowStages(_ inWorkflowStages: String) -> Self{
        query.inWorkflowStages = inWorkflowStages
        return self
    }

    /// After a specific first published date (Format: 2018-03-03 10:00)
    func firstPublishedAfter(_ firstPublishedAtGt: Date) -> Self{
        query.firstPublishedAtGt = firstPublishedAtGt
        return self
    }

    /// Before a specific first published date (Format: 2018-03-03 10:00)
    func firstPublishedBefore(_ firstPublishedAtLt: Date) -> Self{
        query.firstPublishedAtLt = firstPublishedAtLt
        return self
    }

    /// After a specific published date (Format: 2018-03-03 10:00)
    func publishedAfter(_ publishedAtGt: Date) -> Self{
        query.publishedAtGt = publishedAtGt
        return self
    }

    /// Before a specific published date (Format: 2018-03-03 10:00)
    func publishedBefore(_ publishedAtLt: Date) -> Self{
        query.publishedAtLt = publishedAtLt
        return self
    }
    
    func ofContentType(_ contentType: String) -> Self{
        query.contentType = contentType
        return self
    }
    
    func atFolderLevel(_ folderLevel: Int) -> Self{
        query.folderLevel = folderLevel
        return self
    }
    
    /// Exclude stories with the id added
    func excludingId(_ excludingId: Int64) -> Self{
        if query.excludingIds == nil {
            query.excludingIds = []
        }
        query.excludingIds?.append(excludingId)
        return self
    }
    
    /// Get stories by UUIDs.
    /// To get a specific language you need to combine this filter with starts_with=en/* (replace en with your langauge)
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/stories}
    func withUUID(_ uuid: UUID) -> Self{
        if query.byUUIDs == nil{
            query.byUUIDs = []
        }
        query.byUUIDs?.append(uuid)
        return self
    }

    /// Get stories added uuid's ordered by the sequence provided
    /// See {https://www.storyblok.com/docs/api/content-delivery#core-resources/stories/stories}
    func WithAndOrderedByUUID(_ uuid: UUID) -> Self{
        if query.byUUIDsOrdered == nil {
            query.byUUIDsOrdered = []
        }
        query.byUUIDsOrdered?.append(uuid)
        return self
    }
    
    func withTag(_ tag: String) -> Self{
        query.withTag = tag
        return self
    }
    
    /// Filter by folder startpage. Use {true} to only return startpages and {false} to exclude startpages from the result.
    func thatAreStartPages(_ startPage: Bool) -> Self{
        query.isStartPage = startPage
        return self
    }
    
}
