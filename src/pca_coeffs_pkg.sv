// PCA Coefficients Package
// Auto-generated from model/pca_coeffs.json

`ifndef PCA_COEFFS_PKG_SV
`define PCA_COEFFS_PKG_SV

package pca_coeffs_pkg;

    parameter N_FEATURES = 28;
    parameter Q = 4;
    parameter R = 2;
    parameter DATA_WIDTH = 32;
    parameter FRAC_BITS = 8;
    
    // Mean vector (fixed-point)
    parameter logic signed [DATA_WIDTH-1:0] MEAN [N_FEATURES-1:0] = '{
        32'sd0,  // Feature 0
        32'sd0,  // Feature 1
        32'sd0,  // Feature 2
        32'sd0,  // Feature 3
        32'sd7,  // Feature 4
        32'sd3,  // Feature 5
        32'sd0,  // Feature 6
        32'sd0,  // Feature 7
        32'sd0,  // Feature 8
        32'sd0,  // Feature 9
        32'sd0,  // Feature 10
        32'sd194,  // Feature 11
        32'sd0,  // Feature 12
        32'sd0,  // Feature 13
        32'sd0,  // Feature 14
        32'sd0,  // Feature 15
        32'sd0,  // Feature 16
        32'sd0,  // Feature 17
        32'sd0,  // Feature 18
        32'sd0,  // Feature 19
        32'sd0,  // Feature 20
        32'sd1,  // Feature 21
        32'sd59,  // Feature 22
        32'sd60,  // Feature 23
        32'sd0,  // Feature 24
        32'sd0,  // Feature 25
        32'sd0,  // Feature 26
        32'sd0  // Feature 27
    };

    // Major components matrix
    parameter logic signed [DATA_WIDTH-1:0] MAJOR_COMPONENTS [Q-1:0][N_FEATURES-1:0] = '{
        '{
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0
        },  // Major component 0
        '{
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0
        },  // Major component 1
        '{
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0
        },  // Major component 2
        '{
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0
        }  // Major component 3
    };

    // Minor components matrix
    parameter logic signed [DATA_WIDTH-1:0] MINOR_COMPONENTS [R-1:0][N_FEATURES-1:0] = '{
        '{
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd1,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0
        },  // Minor component 0
        '{
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd9,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd13,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0,
            32'sd0
        }  // Minor component 1
    };

endpackage

`endif // PCA_COEFFS_PKG_SV
