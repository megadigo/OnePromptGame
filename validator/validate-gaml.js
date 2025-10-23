/**
 * GAML Validation Script
 * Validates GAML (YAML) files against the gaml-schema.json JSON Schema
 * Fetches schema from GitHub URL specified in each GAML file
 */

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');
const Ajv = require('ajv');
const https = require('https');

// Initialize AJV with draft-07 support
const ajv = new Ajv({ 
  allErrors: true, 
  verbose: true,
  strict: false 
});

// Cache for downloaded schemas
const schemaCache = new Map();

/**
 * Fetch schema from GitHub URL
 */
function fetchSchema(url) {
  return new Promise((resolve, reject) => {
    // Check cache first
    if (schemaCache.has(url)) {
      return resolve(schemaCache.get(url));
    }

    // Convert GitHub blob URL to raw content URL
    const rawUrl = url
      .replace('github.com', 'raw.githubusercontent.com')
      .replace('/blob/', '/');

    console.log(`  Fetching schema from: ${rawUrl}`);

    https.get(rawUrl, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        if (res.statusCode === 200) {
          try {
            const schema = JSON.parse(data);
            schemaCache.set(url, schema);
            resolve(schema);
          } catch (error) {
            reject(new Error(`Failed to parse schema JSON: ${error.message}`));
          }
        } else {
          reject(new Error(`Failed to fetch schema: HTTP ${res.statusCode}`));
        }
      });
    }).on('error', (error) => {
      reject(new Error(`Network error: ${error.message}`));
    });
  });
}

/**
 * Recursively find all .gaml files in a directory
 */
function findGamlFiles(dir, fileList = []) {
  const files = fs.readdirSync(dir);

  files.forEach(file => {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);

    if (stat.isDirectory()) {
      // Skip node_modules and .git directories
      if (file !== 'node_modules' && file !== '.git') {
        findGamlFiles(filePath, fileList);
      }
    } else if (file.endsWith('.gaml')) {
      fileList.push(filePath);
    }
  });

  return fileList;
}

// Crawl project to find all GAML files
const projectRoot = path.join(__dirname, '..');
const gamlFilesAbsolute = findGamlFiles(projectRoot);

console.log('='.repeat(80));
console.log('GAML FILE VALIDATION');
console.log('='.repeat(80));
console.log(`Project root: ${projectRoot}`);
console.log(`Files to validate: ${gamlFilesAbsolute.length}`);
console.log('='.repeat(80));
console.log('');

let allValid = true;
const results = [];

// Validate each file (async)
(async () => {
  for (let index = 0; index < gamlFilesAbsolute.length; index++) {
    const fullPath = gamlFilesAbsolute[index];
    const relativePath = path.relative(projectRoot, fullPath);
    console.log(`[${index + 1}/${gamlFilesAbsolute.length}] Validating: ${relativePath}`);
    console.log('-'.repeat(80));
    
    try {
      // Check if file exists
      if (!fs.existsSync(fullPath)) {
        console.log(`❌ ERROR: File not found at ${fullPath}`);
        results.push({ file: relativePath, valid: false, error: 'File not found' });
        allValid = false;
        console.log('');
        continue;
      }

      // Read and parse YAML
      const yamlContent = fs.readFileSync(fullPath, 'utf8');
      const data = yaml.load(yamlContent);

      // Get schema URL from GAML file
      const schemaUrl = data.schema;
      if (!schemaUrl) {
        console.log(`❌ ERROR: No schema property found in GAML file`);
        results.push({ file: filePath, valid: false, error: 'No schema URL specified' });
        allValid = false;
        console.log('');
        continue;
      }

      console.log(`  Schema URL: ${schemaUrl}`);

      // Fetch and compile schema
      const schema = await fetchSchema(schemaUrl);
      const validate = ajv.compile(schema);

      // Validate against schema
      const valid = validate(data);

    if (valid) {
      console.log(`✅ VALID: File conforms to schema`);
      results.push({ file: relativePath, valid: true });
    } else {
      console.log(`❌ INVALID: Schema validation failed`);
      console.log(`\nErrors found: ${validate.errors.length}`);
      validate.errors.forEach((error, i) => {
        console.log(`\n  Error ${i + 1}:`);
        console.log(`    Path: ${error.instancePath || '(root)'}`);
        console.log(`    Message: ${error.message}`);
        if (error.params) {
          console.log(`    Params: ${JSON.stringify(error.params)}`);
        }
      });
      results.push({ 
        file: relativePath, 
        valid: false, 
        errors: validate.errors.map(e => ({
          path: e.instancePath,
          message: e.message,
          params: e.params
        }))
      });
      allValid = false;
    }

    // Additional checks
    console.log(`\nFile statistics:`);
    console.log(`  - File: ${data.file || 'N/A'}`);
    console.log(`  - Version: ${data.version || 'N/A'}`);
    console.log(`  - Game Name: ${data.game?.name || 'N/A'}`);
    console.log(`  - Game Type: ${data.game?.type || 'N/A'}`);
    console.log(`  - Schema Reference: ${data.schema || 'N/A'}`);
    
    // Check schema reference
    const expectedSchema = 'https://github.com/megadigo/gaml-schema';
    if (data.schema && !data.schema.includes('megadigo/gaml-schema')) {
      console.log(`  ⚠️  WARNING: Schema reference may be incorrect`);
      console.log(`     Expected to contain: ${expectedSchema}`);
    }

    } catch (error) {
      console.log(`❌ ERROR: ${error.message}`);
      results.push({ file: relativePath, valid: false, error: error.message });
      allValid = false;
    }

    console.log('');
  }

  // Summary
  console.log('='.repeat(80));
  console.log('VALIDATION SUMMARY');
  console.log('='.repeat(80));
  console.log(`Total files: ${gamlFilesAbsolute.length}`);
  console.log(`Valid: ${results.filter(r => r.valid).length}`);
  console.log(`Invalid: ${results.filter(r => !r.valid).length}`);
  console.log('');

  if (allValid) {
    console.log('✅ All GAML files are valid!');
  } else {
    console.log('❌ Some GAML files have validation errors.');
    console.log('');
    console.log('Files with errors:');
    results.filter(r => !r.valid).forEach(r => {
      console.log(`  - ${r.file}`);
    });
  }
  console.log('='.repeat(80));

  // Save individual result files for each GAML file
  console.log('\nSaving individual validation results...');
  const resultsDir = path.join(__dirname, 'results');
  if (!fs.existsSync(resultsDir)) {
    fs.mkdirSync(resultsDir, { recursive: true });
  }

  results.forEach(result => {
    const gamlFileName = path.basename(result.file, '.gaml');
    const resultFileName = `${gamlFileName}-validation.json`;
    const resultFilePath = path.join(resultsDir, resultFileName);
    
    fs.writeFileSync(resultFilePath, JSON.stringify({
      timestamp: new Date().toISOString(),
      gamlFile: result.file,
      valid: result.valid,
      errors: result.errors || null,
      error: result.error || null
    }, null, 2));
    
    console.log(`  ✓ ${resultFileName}`);
  });

  // Also save summary file
  const summaryPath = path.join(resultsDir, 'validation-summary.json');
  fs.writeFileSync(summaryPath, JSON.stringify({ 
    timestamp: new Date().toISOString(),
    projectRoot: projectRoot,
    filesValidated: gamlFilesAbsolute.length,
    results: results,
    summary: {
      total: gamlFilesAbsolute.length,
      valid: results.filter(r => r.valid).length,
      invalid: results.filter(r => !r.valid).length,
      allValid: allValid
    }
  }, null, 2));
  console.log(`  ✓ validation-summary.json`);
  console.log(`\nAll results saved to: ${resultsDir}`);

  // Exit with appropriate code
  process.exit(allValid ? 0 : 1);
})();
