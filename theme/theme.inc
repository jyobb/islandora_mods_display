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

  // MAM additions for MADS completed on 30-March-2015
  // If the object has a MADS record, display it in place of the MODS record.

  $mods = FALSE;

  if ($object['MADS']) {
    $mods = $object['MADS']->content;
  } else if (islandora_datastream_access(ISLANDORA_VIEW_OBJECTS, $object['MODS'])) {
    try {
      $mods = $object['MODS']->content;
    }
    catch (Exception $e) {
      drupal_set_message(t('Error retrieving object %s %t', array('%s' => $object->id, '%t' => $e->getMessage())), 'error', FALSE);
    }
  }

  if ($mods) {
    $file = drupal_get_path('module', 'islandora_mods_display') . '/xsl/mods_display.xsl';
    $xslt = new XSLTProcessor();
    $xslt_dom = new DOMDocument();
    if (!$xslt_dom->load($file)) {
      drupal_set_message("Error loading ./xsl/mods_display.xsl transform in islandora_mods_display_preprocess_islandora_mods_display_display( )!", 'error');
      return;
    }

    $input = new DOMDocument();
    $did_load_ok = $input->loadXML($mods);
    if ($did_load_ok) {
      if (!$xslt->importStylesheet($xslt_dom)) {
        drupal_set_message("Error loading XSLT as transform stylesheet in islandora_mods_display_preprocess_islandora_mods_display_display( )!", 'error');
        return;
      }
      if (!$variables['metadata'] = $xslt->transformToXml($input)) {
        drupal_set_message("Error transforming MODS in islandora_mods_display_preprocess_islandora_mods_display_display( )!", 'error');
        return;
      }
    } else {
      drupal_set_message("Error loading MODS content as XML in islandora_mods_display_preprocess_islandora_mods_display_display( )!", 'error');
      return;
    }
  }

  // MAM additions to include parent object metadata when looking at an object
  // which is a child of a compound object.

  if ($object['RELS-EXT']) {
    $rels = $object->relationships->get('info:fedora/fedora-system:def/relations-external#', 'isConstituentOf');
    foreach ($rels as $rel) {
      $parentID = $rel['object']['value'];
      if ($parent = islandora_object_load($parentID)) {
        if (in_array('islandora:compoundCModel', $parent->models)) {
          $mods = $parent['MODS']->content;
          $file = drupal_get_path('module', 'islandora_mods_display') . '/xsl/mods_display.xsl';
          $xslt = new XSLTProcessor();
          $xslt_dom = new DOMDocument();
          $xslt_dom->load($file);
          $input = new DOMDocument();
          $did_load_ok = $input->loadXML($mods);
          if ($did_load_ok) {
            $xslt->importStylesheet($xslt_dom);
            $variables['metadata'] .= $xslt->transformToXml($input);
            $variables['metadata'] = islandora_mods_display_remove_redundant_rows($variables['metadata']);
          }
        }
      }
    }
  }
}

/**
 * MAM authored helper function to 'hide' redundant table rows from MODS display.
 *
 * @param $metadata
 *   Array of metadata table rows to be displayed.
 */
function islandora_mods_display_remove_redundant_rows($metadata) {

  // Explode the metadata into an array of <tr> elements.
  $elements = explode("</tr>", $metadata);
  $count = count($elements);
  $redundant = 0;

  // Dump the $elements array...
  echo "<pre> islandora_mods_display_remove_redundant_rows: Before <br/>";
  var_dump($elements);
  echo "</pre>";

  // Loop on all the elements.  Add a class="hidden" attribute to the 2nd, 3rd, 4th, etc.
  // redundant (matching) elements.
  foreach ($elements as $i => $row) {
    for ($j=$i+1; $j<$count; $j++) {
      if (!strstr($row, 'do-not-hide') && $elements[$j] === $row) {
        $elements[$i] = str_replace('<tr>', '<tr class="hidden">', $elements[$i]);
        $redundant++;
      }
    }
  }

  // Dump the $elements array...
  echo "<pre> islandora_mods_display_remove_redundant_rows: After <br/>";
  var_dump($elements);
  echo "</pre>";

  // Put the metadata back together from the modified $elements.
  if ($redundant) {
    $returned = implode('</tr>', $elements);
    return $returned;
  } else {
    return $metadata;
  }

}


/**
 * Implements hook_preprocess().
 *
 * MAM customized on 20-Oct-2015.
 *
 */
function islandora_mods_display_preprocess_islandora_mods_display_description(array &$variables) {
  $object = $variables['islandora_object'];

  /* MAM...Replace $description ($object->label) with the /mods/ for all DG objects.  20-Oct-2015
    $variables['description'] = t('@object', array('@object' => $object->label,)); */

  $variables['description'] = '';    // initialize to blank

  // Check for /mods/abstract with or without the explicit 'mods' namespace prefix.
  if ($mods = $object['MODS']) {
    $xml = new DOMDocument;
    $xml->loadXML($mods->content);
    $mx = new DOMXPath($xml);
    $mx->registerNamespace('mods', 'http://www.loc.gov/mods/v3');  // MAM added 15-June-2016
    $xpath = "/mods/abstract";
    if ($elements = $mx->query($xpath)) {
      if ($elements->length == 0) {
        $xpath = "/mods:mods/mods:abstract";
        if ($elements = $mx->query($xpath)) {
          if ($elements->length > 0) {
            $variables['description'] = t('@object', array('@object' => $elements->item(0)->nodeValue,));
          }
        }
      } else {
        $variables['description'] = t('@object', array('@object' => $elements->item(0)->nodeValue,));
      }
    }
  }
}
