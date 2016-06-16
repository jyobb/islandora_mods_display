<?php
/**
 * @file
 * This is the template file for the metadata display for an object.
 *
 * Available variables:
 * - $islandora_object: The Islandora object rendered in this template file
 * - $metadata: XSLT output
 *
 * @see template_preprocess_unicorns_are_awesome_display()
 * @see theme_unicorns_are_awesome_display()
 */
?>
<?php if (isset($metadata)) { print $metadata; }?>