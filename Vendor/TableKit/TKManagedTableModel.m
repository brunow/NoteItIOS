//
//  BKTableModelManagedListDataController.m
//  CellMappingExample
//
//  Created by Bruno Wernimont on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TKManagedTableModel.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TKManagedTableModel

@synthesize fetchedResultsController = _fetchedResultsController;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [super objectForRowAtIndexPath:indexPath];
    
    if (nil == object) {
        return [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    return object;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSections {
    return [[self.fetchedResultsController sections] count];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFetchedResultsControllerWithBlock:(TKManagedTableModelFetchedResultsControllerBlock)block {
    self.fetchedResultsController = block();
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadItems {
    [self.fetchedResultsController performFetch:nil];
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Getters and setters


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    _fetchedResultsController = fetchedResultsController;
    _fetchedResultsController.delegate = self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    int count = [self numberOfSections];
    
    if (count > section) {
        id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    }
    
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
    
    if ([_fetchedResultsControllerDelegate respondsToSelector:@selector(controllerWillChangeContent:)]) {
        [_fetchedResultsControllerDelegate controllerWillChangeContent:controller];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
    if ([_fetchedResultsControllerDelegate respondsToSelector:@selector(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:)]) {
        [_fetchedResultsControllerDelegate controller:controller
                                      didChangeObject:anObject
                                          atIndexPath:indexPath
                                        forChangeType:type
                                         newIndexPath:newIndexPath];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
    if ([_fetchedResultsControllerDelegate respondsToSelector:@selector(controller:didChangeSection:atIndex:forChangeType:)]) {
        [_fetchedResultsControllerDelegate controller:controller
                                     didChangeSection:sectionInfo
                                              atIndex:sectionIndex
                                        forChangeType:type];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    
    if ([_fetchedResultsControllerDelegate respondsToSelector:@selector(controllerDidChangeContent:)]) {
        [_fetchedResultsControllerDelegate controllerDidChangeContent:controller];
    }
}


@end
