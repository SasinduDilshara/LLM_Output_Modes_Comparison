map<json> prompt1Schema = {
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "sessions": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "title": {
            "type": "string"
          },
          "date": {
            "type": "string"
          },
          "time": {
            "type": "string"
          },
          "location": {
            "type": "string"
          },
          "speakers": {
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          "description": {
            "type": "string"
          }
        },
        "required": [
          "title",
          "date",
          "time",
          "location",
          "speakers",
          "description"
        ]
      }
    },
    "products": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "description": {
            "type": "string"
          }
        },
        "required": [
          "name",
          "description"
        ]
      }
    },
    "customer": {
      "type": "object",
      "properties": {
        "companyName": {
          "type": "string"
        },
        "usageSummary": {
          "type": "string"
        }
      },
      "required": [
        "companyName",
        "usageSummary"
      ]
    },
    "user": {
      "type": "object",
      "properties": {
        "attendeeName": {
          "type": "string"
        },
        "company": {
          "type": "string"
        },
        "role": {
          "type": "string"
        }
      },
      "required": [
        "attendeeName",
        "company",
        "role"
      ]
    }
  },
  "required": [
    "sessions",
    "products",
    "customer",
    "user"
  ]
};

map<json> prompt2Schema = {
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "id": {
      "type": "string"
    },
    "reason": {
      "type": "string"
    },
    "tags": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "minItems": 2
    }
  },
  "required": [
    "id",
    "reason",
    "tags"
  ]
};

map<json> prompt3Schema = {
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "value": {
      "type": "array",
      "items": {
        "type": "integer"
      }
    }
  },
  "required": [
    "value"
  ]
};

map<json> prompt4Schema = {
  "type": "object",
  "properties": {
    "value": {
      "type": "array",
      "items": {
        "type": "string"
      }
    }
  },
  "required": [
    "value"
  ]
};

map<json> prompt5Schema = {
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "value": {
      "type": "string"
    }
  },
  "required": [
    "value"
  ]
};

map<json> prompt6Schema = {
  "type": "object",
  "properties": {
    "value": {
      "type": "integer"
    }
  },
  "required": [
    "value"
  ]
};

map<json> prompt7Schema = {
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "customer": {
      "type": "object",
      "properties": {
        "Name": { "type": "string" },
        "Age": { "type": "integer" },
        "Email": { "type": "string", "format": "email" },
        "Address": { "type": "string" },
        "Phone": { "type": "string" },
        "Orders": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "OrderID": { "type": "string" },
              "ProductName": { "type": "string" },
              "Quantity": { "type": "integer" },
              "Price": { "type": "number", "minimum": 0 },
              "Date": { "type": "string", "format": "date" }
            },
            "required": ["OrderID", "ProductName", "Quantity", "Price", "Date"]
          }
        }
      },
      "required": ["Name", "Age", "Email", "Address", "Phone", "Orders"]
    },
    "employee": {
      "type": "object",
      "properties": {
        "EmployeeID": { "type": "string" },
        "Name": { "type": "string" },
        "Position": { "type": "string" },
        "Department": { "type": "string" },
        "HireDate": { "type": "string", "format": "date" },
        "Skills": {
          "type": "array",
          "items": { "type": "string" }
        }
      },
      "required": ["EmployeeID", "Name", "Position", "Department", "HireDate", "Skills"]
    },
    "company": {
      "type": "object",
      "properties": {
        "CompanyName": { "type": "string" },
        "Founded": { "type": "string" },
        "Location": { "type": "string" },
        "Employees": { "type": "integer", "minimum": 0 },
        "AnnualRevenue": { "type": "number", "minimum": 0 },
        "Industry": { "type": "string" }
      },
      "required": ["CompanyName", "Founded", "Location", "Employees", "AnnualRevenue", "Industry"]
    }
  },
  "required": ["customer", "employee", "company"],
  "additionalProperties": false
};

map<json> prompt8Schema = {
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Event",
  "type": "object",
  "properties": {
    "eventName": { "type": "string" },
    "eventDate": { "type": "string" },
    "location": { "type": "string" },
    "companyName": { "type": "string" },
    "keynoteSpeaker": { "type": "string" },
    "keynoteTopic": { "type": "string" },
    "numberOfAttendees": { 
      "type": "integer",
      "minimum": 0 
    },
    "industriesRepresented": {
      "type": "array",
      "items": { "type": "string" }
    },
    "productsAnnounced": {
      "type": "array",
      "items": { "type": "string" }
    },
    "executiveNames": {
      "type": "array",
      "items": { "type": "string" }
    },
    "panelModeratorName": { "type": "string" },
    "panelModeratorAffiliation": { "type": "string" }
  },
  "required": [
    "eventName",
    "eventDate",
    "location",
    "companyName",
    "keynoteSpeaker",
    "keynoteTopic",
    "numberOfAttendees",
    "industriesRepresented",
    "productsAnnounced",
    "executiveNames",
    "panelModeratorName",
    "panelModeratorAffiliation"
  ],
  "additionalProperties": false
};

map<json> prompt9Schema = prompt2Schema;
