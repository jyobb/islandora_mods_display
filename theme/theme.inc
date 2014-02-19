<?php
/**
 * @file
 * This file contains all theme and preprocess functions for islandora_mods_display.
 */


/**
 * Implements hook_preprocess().
 */
function islandora_mods_display_preprocess_islandora_mods_display_display(array &$variables) {
  $object = $variables['islandora_object'];

  if (islandora_datastream_access(ISLANDORA_VIEW_OBJECTS, $object['MODS'])) {
    try {
      $mods = $object['MODS']->content;
    }
    catch (Exception $e) {
      drupal_set_message(t('Error retrieving object %s %t', array('%s' => $object->id, '%t' => $e->getMessage())), 'error', FALSE);
    }
  }

  if ($mods) {

  $params = array('title' => 'Titles',
		  'name' => 'Name', 
		  'classification' => 'Classification', 
		  'subjectTopic' => 'Subject Topic',
		  'subjectOccupation' => 'Subject Occupation',
		  'subjectName' => 'Subject Name',
		  'subjectGeographic' => 'Subject Geographic',
		  'subjectHierGeographic' => 'Subject Hierarchical Geographic',
		  'subjectCartographic' => 'Subject Cartographic',
		  'subjectTemporal' => 'Subject Temporal',
		  'subjectLocalname' => 'Subject Local Name',
		  'abstract' => 'Abstract',
		  'toc' => 'Table of Contents',
		  'note' => 'Note',
		  'dateIssued' => 'Date Issued',
		  'dateCreated' => 'Date Created',
		  'dateCaptured' => 'Date Captured',
		  'dateOther' => 'Date Other',
		  'publisher' => 'Publisher',
		  'genre' => 'Genre',
		  'typeOfResource' => 'Type of Resource',
		  'extent' => 'Extent',
		  'form' => 'Form',
		  'mediaType' => 'Media Type',
		  'mimeType' => 'Mime Type',
		  'identifier' => 'Identifier',
		  'physicalLocation' => 'Physical Location',
		  'shelfLocation' => 'Shelf Location',
		  'url' => 'URL',
		  'holdingSubLocation' => 'Holding Sublocation',
		  'holdingShelfLocator' => 'Holding Shelf Locator',
		  'electronicLocator' => 'Electronic Locator',
		  'language' => 'Language',
		  'relatedItem' => 'Related Item',
		  'accessCondition' => 'Access Condition');


      $file = drupal_get_path('module', 'islandora_mods_display') . '/xsl/mods_display.xsl';
      $xslt = new XSLTProcessor();
      $xslt_dom = new DOMDocument();
      $xslt_dom->load($file);
      $input = new DOMDocument();
      $did_load_ok = $input->loadXML($mods);
      if ($did_load_ok) {
      $xslt->importStylesheet($xslt_dom);
      foreach($params as $k => $v){
      //debug for fun
      //drupal_set_message($k);
      $xslt->setParameter('',$k,$v);
      }

      $variables['metadata'] = $xslt->transformToXml($input);
      }
  }
}




/**
 * Implements hook_preprocess().
 */
function islandora_mods_display_preprocess_islandora_mods_display_description(array &$variables) {
  $object = $variables['islandora_object'];
  //print_r($object);
  $variables['description'] = t('@object', array('@object' => $object->label,));
}
