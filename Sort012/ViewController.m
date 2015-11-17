//
//  ViewController.m
//  Sort012
//
//  Created by Vinh Khoa Nguyen on 14/11/2015.
//  Copyright © 2015 Vinh Khoa Nguyen. All rights reserved.
//
//  Sort an array containing only 0s, 1s or 2s

#import "ViewController.h"

static NSUInteger const kArraySize = 6; // Change this value to test with array combinations of different sizes
static NSUInteger const kArrayPossibleValues = 3; // Even though this appears to be a constant that can be changed, it in fact has to be 3 as our sort functions expect this to be 3 :-)

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	// Get all the possible combinations of 0, 1 & 2 in an array of certain size.
	// Sort them to make the result easier to follow. The list should be sorted by default anyway but do this just in case.
	NSMutableArray *arrays = [self allArrayCombinationsOfSize:kArraySize];
	[arrays sortedArrayUsingComparator:^NSComparisonResult(NSArray *array1, NSArray *array2) {
		return [[self concatenateValuesInArray:array1] compare:[self concatenateValuesInArray:array2]];
	}];

	NSDate *startTime = [NSDate date];

	// Sort each of the array inside the arrays and assert that they are in fact sorted
	for (NSMutableArray *array in arrays) {
		// Sort the array and display its result in NSLog
		NSString *before = [self concatenateValuesInArray:array];
		[self sortArray:array];
		NSString *after = [self concatenateValuesInArray:array];
		NSLog(@"%@ -> %@", before, after);

		// Stop if any array is not correctly sorted
		NSAssert([self validateSortedArray:array], @"Array not sorted");
	}

	// Calculate elapsed time
	NSDate *endTime = [NSDate date];
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitNanosecond fromDate:startTime toDate:endTime options:0];
	NSLog(@"Sorted %lu arrays in %.0fms.", (unsigned long)arrays.count, ((double)components.nanosecond / 1000000));

	[[[UIAlertView alloc] initWithTitle:@"Finished" message:@"All arrays have been sorted. Please see logs for results." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
}


#pragma mark - Sorting

/// Sort the array in ascending order: 0000...1111...2222
- (void)sortArray:(NSMutableArray *)array
{
	NSUInteger last0Index = -1, first2Index = array.count;
	NSUInteger i = 0;

	while (i < first2Index) {
		// Meeting a 0: move it to the beginning
		if ([array[i] intValue] == 0) {
			[self swapValueAtIndex:i withIndex:(last0Index + 1) inArray:array];
			last0Index++;
			i++;
		}

		// Meeting a 1: nothing to swap, move on and check the next element
		else if ([array[i] intValue] == 1) {
			i++;
		}

		// Meeting a 2: move it to the end
		else if ([array[i] intValue] == 2) {
			[self swapValueAtIndex:i withIndex:(first2Index - 1) inArray:array];
			first2Index--;
		}
	}
}


#pragma mark - Swapping

/// Swap values at the 2 indexes inside the specified array. Please note, in this excertise, each element in the array
/// is an NSNumber. So to keep it simple, we don't actually swap the objects, but just its value.
- (void)swapValueAtIndex:(NSUInteger)index1 withIndex:(NSUInteger)index2 inArray:(NSMutableArray *)array
{
	// Do nothing if 2 indexes are the same
	if (index1 == index2)
	{
		return;
	}

	// Swap values of the 2 objects
	int temp = [array[index1] intValue];
	array[index1] = @([array[index2] intValue]);
	array[index2] = @(temp);
}


#pragma mark - Other helpers

/// Concatenate all of the array values together into a single string
- (NSString *)concatenateValuesInArray:(NSArray *)array
{
	return [array componentsJoinedByString:@""];
}

/// Recursive function to generate all possible combinations of an array of 0s, 1s & 2s
- (NSMutableArray *)allArrayCombinationsOfSize:(NSUInteger)size
{
	// Stop condition 1: return empty array for size of 0
	if (size == 0) {
		return [NSMutableArray array];
	}

	// Stop condition 2: return an array of single item arrays
	else if (size == 1) {
		NSMutableArray *result = [NSMutableArray array];
		for (int i = 0; i < kArrayPossibleValues; i++) {
			[result addObject:[NSMutableArray arrayWithObject:@(i)]];
		}

		return result;
	}

	NSMutableArray *result = [NSMutableArray array];

	// Use recursion to get the leading array of arrays. Then for each of those arrays, append the last value
	NSMutableArray *leadingArrays = [self allArrayCombinationsOfSize:(size - 1)];
	for (NSMutableArray *array in leadingArrays) {
		for (int i = 0; i < kArrayPossibleValues; i++) {
			NSMutableArray *thisArray = [array mutableCopy];
			[thisArray addObject:@(i)];
			[result addObject:thisArray];
		}
	}

	return result;
}

/// Generate a random of array with the specified size containing only 0s, 1s or 2s
- (NSMutableArray *)randomArrayOfSize:(NSUInteger)size
{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:size];
	for (NSUInteger i = 0; i < size; i++) {
		[result addObject:[NSNumber numberWithInt:arc4random_uniform(kArrayPossibleValues)]];
	}

	return result;
}

/// Return YES if the array is sorted in ascending order, NO otherwise.
- (BOOL)validateSortedArray:(NSArray *)array
{
	BOOL result = YES;
	for (int i = 0; i < array.count - 1; i++) {
		// Every element should be equal to or less than the one on its right
		if ([array[i] intValue] > [array[i+1] intValue]) {
			result = NO;
			break;
		}
	}

	return result;
}

@end
