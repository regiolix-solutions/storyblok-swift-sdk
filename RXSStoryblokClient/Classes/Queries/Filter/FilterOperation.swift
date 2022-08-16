//
//  FilterOperation.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public enum FilterOperation: String{
    /**
     * Matches exactly one value
     */
    case In = "in"
    /**
     * Matches all without the given value
     */
    case NotIn = "not_in"
    /**
     * Matches exactly one value with a wildcard search using * (Example: "john*")
     */
    case Like = "like"
    /**
     * Matches all without the given value
     */
    case NotLike = "not_like"
    /**
     * Matches any value of given array
     */
    case InArray = "in_array"
    /**
     * Must match all values of given array
     */
    case AllInArray = "all_in_array"
    /**
     * Greater than date (Format: YYYY-mm-dd HH:MM)
     */
    case AfterDate = "gt_date"
    /**
     * Less than date (Format:  YYYY-mm-dd HH:MM)
     */
    case BeforeDate = "lt_date"
    /**
     * Greater than integer value
     */
    case GreaterThanInteger = "gt_int"
    /**
     * Less than integer value
     */
    case LessThanInteger = "lt_int"
    /**
     * Greater than float value
     */
    case GreaterThanFloat = "gt_float"
    /**
     * Less than float value
     */
    case LessThanFloat = "lt_float"
}
