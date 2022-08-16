//
//  StoryblokQueryParameter.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

enum StoryblokQueryParameter: String{
    case StartsWith(String) = "starts_with"
    case ByUUIDs([UUID]) = "by_uuids"
    case BySlugs([String])
    case ExcludingSlugs([String])
    case ByUUIDsOrdered([UUID])
    case ExcludingIds([Int64])
    case ExcludingFields([String])
    case InWorkflowStages(String)
    case SearchTerm(String)
    case FirstPublishedAtGt(Date)
    case FirstPublishedAtLt(Date)
    case PublishedAtGt(Date)
    case PublishedAtLt(Date)
    case IsStartPage(Bool)
    case Page(Int)
    case PerPage(Int)

    case FindBy(String)
    case Version(StoryVersion)
    case ResolveLinks(ResolveLinks)
    case ResolveRelations(String)
    case RromRelease(String)
    case Cv(String)
    case Language(String)
    case FallbackLang(String)
    case FilterQueryParameters(Set<FilterQueryParameter>)
}
