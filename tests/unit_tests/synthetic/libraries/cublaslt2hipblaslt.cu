// RUN: %run_test hipify "%s" "%t" %hipify_args 3 --amap --skip-excluded-preprocessor-conditional-blocks --experimental %clang_args -D__CUDA_API_VERSION_INTERNAL -ferror-limit=500

// CHECK: #include <hip/hip_runtime.h>
#include <cuda_runtime.h>
#include <stdio.h>
// CHECK: #include "hipblaslt.h"
#include "cublasLt.h"
// CHECK-NOT: #include "hipblaslt.h"

#if defined(_WIN32) && CUDA_VERSION < 9000
  typedef signed   __int64 int64_t;
  typedef unsigned __int64 uint64_t;
#endif

int main() {
  printf("20. cuBLASLt API to hipBLASLt API synthetic test\n");

  // CHECK: hipblasLtHandle_t blasLtHandle;
  cublasLtHandle_t blasLtHandle;

  // CHECK: hipblasStatus_t status;
  cublasStatus_t status;

  // CHECK: hipStream_t stream;
  cudaStream_t stream;

  void *A = nullptr;
  void *B = nullptr;
  void *C = nullptr;
  void *D = nullptr;
  void *alpha = nullptr;
  void *beta = nullptr;
  void *workspace = nullptr;
  void *buf = nullptr;
  const char *const_ch = nullptr;

  size_t workspaceSizeInBytes = 0;
  size_t sizeWritten = 0;
  uint64_t rows = 0;
  uint64_t cols = 0;
  int64_t ld = 0;

#if CUDA_VERSION >= 8000
  // CHECK: hipDataType dataType, dataTypeA, dataTypeB, computeType;
  cudaDataType dataType, dataTypeA, dataTypeB, computeType;
#endif

#if CUDA_VERSION >= 10010
  // CHECK: hipblasLtMatmulAlgo_t blasLtMatmulAlgo;
  cublasLtMatmulAlgo_t blasLtMatmulAlgo;

  // CHECK: hipblasLtMatmulDesc_t blasLtMatmulDesc;
  cublasLtMatmulDesc_t blasLtMatmulDesc;

  // CHECK: hipblasLtMatrixTransformDesc_t blasLtMatrixTransformDesc;
  cublasLtMatrixTransformDesc_t blasLtMatrixTransformDesc;

  // CHECK: hipblasLtMatmulPreference_t blasLtMatmulPreference;
  cublasLtMatmulPreference_t blasLtMatmulPreference;

  // CHECK: hipblasLtMatrixLayout_t blasLtMatrixLayout, Adesc, Bdesc, Cdesc, Ddesc;
  cublasLtMatrixLayout_t blasLtMatrixLayout, Adesc, Bdesc, Cdesc, Ddesc;

  // CHECK: hipblasLtOrder_t blasLtOrder;
  // CHECK-NEXT: hipblasLtOrder_t BLASLT_ORDER_COL = HIPBLASLT_ORDER_COL;
  // CHECK-NEXT: hipblasLtOrder_t BLASLT_ORDER_ROW = HIPBLASLT_ORDER_ROW;
  cublasLtOrder_t blasLtOrder;
  cublasLtOrder_t BLASLT_ORDER_COL = CUBLASLT_ORDER_COL;
  cublasLtOrder_t BLASLT_ORDER_ROW = CUBLASLT_ORDER_ROW;

  // CHECK: hipblasLtMatrixLayoutAttribute_t blasLtMatrixLayoutAttribute;
  // CHECK-NEXT: hipblasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_TYPE = HIPBLASLT_MATRIX_LAYOUT_TYPE;
  // CHECK-NEXT: hipblasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_ORDER = HIPBLASLT_MATRIX_LAYOUT_ORDER;
  // CHECK-NEXT: hipblasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_ROWS = HIPBLASLT_MATRIX_LAYOUT_ROWS;
  // CHECK-NEXT: hipblasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_COLS = HIPBLASLT_MATRIX_LAYOUT_COLS;
  // CHECK-NEXT: hipblasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_LD = HIPBLASLT_MATRIX_LAYOUT_LD;
  // CHECK-NEXT: hipblasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_BATCH_COUNT = HIPBLASLT_MATRIX_LAYOUT_BATCH_COUNT;
  // CHECK-NEXT: hipblasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_STRIDED_BATCH_OFFSET = HIPBLASLT_MATRIX_LAYOUT_STRIDED_BATCH_OFFSET;
  cublasLtMatrixLayoutAttribute_t blasLtMatrixLayoutAttribute;
  cublasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_TYPE = CUBLASLT_MATRIX_LAYOUT_TYPE;
  cublasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_ORDER = CUBLASLT_MATRIX_LAYOUT_ORDER;
  cublasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_ROWS = CUBLASLT_MATRIX_LAYOUT_ROWS;
  cublasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_COLS = CUBLASLT_MATRIX_LAYOUT_COLS;
  cublasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_LD = CUBLASLT_MATRIX_LAYOUT_LD;
  cublasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_BATCH_COUNT = CUBLASLT_MATRIX_LAYOUT_BATCH_COUNT;
  cublasLtMatrixLayoutAttribute_t BLASLT_MATRIX_LAYOUT_STRIDED_BATCH_OFFSET = CUBLASLT_MATRIX_LAYOUT_STRIDED_BATCH_OFFSET;

  // CUDA: cublasStatus_t CUBLASWINAPI cublasLtCreate(cublasLtHandle_t* lightHandle);
  // HIP: HIPBLASLT_EXPORT hipblasStatus_t hipblasLtCreate(hipblasLtHandle_t* handle);
  // CHECK: status = hipblasLtCreate(&blasLtHandle);
  status = cublasLtCreate(&blasLtHandle);

  // CUDA: cublasStatus_t CUBLASWINAPI cublasLtDestroy(cublasLtHandle_t lightHandle);
  // HIP: HIPBLASLT_EXPORT hipblasStatus_t hipblasLtDestroy(const hipblasLtHandle_t handle);
  // CHECK: status = hipblasLtDestroy(blasLtHandle);
  status = cublasLtDestroy(blasLtHandle);

  // CUDA: cublasStatus_t CUBLASWINAPI cublasLtMatmul(cublasLtHandle_t lightHandle, cublasLtMatmulDesc_t computeDesc, const void* alpha, const void* A, cublasLtMatrixLayout_t Adesc, const void* B, cublasLtMatrixLayout_t Bdesc, const void* beta, const void* C, cublasLtMatrixLayout_t Cdesc, void* D, cublasLtMatrixLayout_t Ddesc, const cublasLtMatmulAlgo_t* algo, void* workspace, size_t workspaceSizeInBytes, cudaStream_t stream);
  // HIP: HIPBLASLT_EXPORT hipblasStatus_t hipblasLtMatmul(hipblasLtHandle_t handle, hipblasLtMatmulDesc_t matmulDesc, const void* alpha, const void* A, hipblasLtMatrixLayout_t Adesc, const void* B, hipblasLtMatrixLayout_t Bdesc, const void* beta, const void* C, hipblasLtMatrixLayout_t Cdesc, void* D, hipblasLtMatrixLayout_t Ddesc, const hipblasLtMatmulAlgo_t* algo, void* workspace, size_t workspaceSizeInBytes, hipStream_t stream);
  // CHECK: status = hipblasLtMatmul(blasLtHandle, blasLtMatmulDesc, alpha, A, Adesc, B, Bdesc, beta, C, Cdesc, D, Ddesc, &blasLtMatmulAlgo, workspace, workspaceSizeInBytes, stream);
  status = cublasLtMatmul(blasLtHandle, blasLtMatmulDesc, alpha, A, Adesc, B, Bdesc, beta, C, Cdesc, D, Ddesc, &blasLtMatmulAlgo, workspace, workspaceSizeInBytes, stream);

  // CUDA: cublasStatus_t CUBLASWINAPI cublasLtMatrixTransform(cublasLtHandle_t lightHandle, cublasLtMatrixTransformDesc_t transformDesc, const void* alpha, const void* A, cublasLtMatrixLayout_t Adesc, const void* beta, const void* B, cublasLtMatrixLayout_t Bdesc, void* C, cublasLtMatrixLayout_t Cdesc, cudaStream_t stream);
  // HIP: HIPBLASLT_EXPORT hipblasStatus_t hipblasLtMatrixTransform(hipblasLtHandle_t lightHandle, hipblasLtMatrixTransformDesc_t transformDesc, const void* alpha, const void* A, hipblasLtMatrixLayout_t Adesc, const void* beta, const void* B, hipblasLtMatrixLayout_t Bdesc, void* C, hipblasLtMatrixLayout_t Cdesc, hipStream_t stream);
  // CHECK: status = hipblasLtMatrixTransform(blasLtHandle, blasLtMatrixTransformDesc, alpha, A, Adesc, beta, B, Bdesc, C, Cdesc, stream);
  status = cublasLtMatrixTransform(blasLtHandle, blasLtMatrixTransformDesc, alpha, A, Adesc, beta, B, Bdesc, C, Cdesc, stream);

  // CUDA: cublasStatus_t CUBLASWINAPI cublasLtMatrixLayoutCreate(cublasLtMatrixLayout_t* matLayout, cudaDataType type, uint64_t rows, uint64_t cols, int64_t ld);
  // HIP: HIPBLASLT_EXPORT hipblasStatus_t hipblasLtMatrixLayoutCreate(hipblasLtMatrixLayout_t* matLayout, hipDataType type, uint64_t rows, uint64_t cols, int64_t ld);
  // CHECK: status = hipblasLtMatrixLayoutCreate(&blasLtMatrixLayout, dataType, rows, cols, ld);
  status = cublasLtMatrixLayoutCreate(&blasLtMatrixLayout, dataType, rows, cols, ld);

  // CUDA: cublasStatus_t CUBLASWINAPI cublasLtMatrixLayoutDestroy(cublasLtMatrixLayout_t matLayout);
  // HIP: HIPBLASLT_EXPORT hipblasStatus_t hipblasLtMatrixLayoutDestroy(const hipblasLtMatrixLayout_t matLayout);
  // CHECK: status = hipblasLtMatrixLayoutDestroy(blasLtMatrixLayout);
  status = cublasLtMatrixLayoutDestroy(blasLtMatrixLayout);

  // CUDA: cublasStatus_t CUBLASWINAPI cublasLtMatrixLayoutSetAttribute(cublasLtMatrixLayout_t matLayout, cublasLtMatrixLayoutAttribute_t attr, const void* buf, size_t sizeInBytes);
  // HIP: HIPBLASLT_EXPORT hipblasStatus_t hipblasLtMatrixLayoutSetAttribute(hipblasLtMatrixLayout_t matLayout, hipblasLtMatrixLayoutAttribute_t attr, const void* buf, size_t sizeInBytes);
  // CHECK: status = hipblasLtMatrixLayoutSetAttribute(blasLtMatrixLayout, blasLtMatrixLayoutAttribute, buf, workspaceSizeInBytes);
  status = cublasLtMatrixLayoutSetAttribute(blasLtMatrixLayout, blasLtMatrixLayoutAttribute, buf, workspaceSizeInBytes);

  // CUDA: cublasStatus_t CUBLASWINAPI cublasLtMatrixLayoutGetAttribute(cublasLtMatrixLayout_t matLayout, cublasLtMatrixLayoutAttribute_t attr, void* buf, size_t sizeInBytes, size_t* sizeWritten);
  // HIP: HIPBLASLT_EXPORT hipblasStatus_t hipblasLtMatrixLayoutGetAttribute(hipblasLtMatrixLayout_t matLayout, hipblasLtMatrixLayoutAttribute_t attr, void* buf, size_t sizeInBytes, size_t* sizeWritten);
  // CHECK: status = hipblasLtMatrixLayoutGetAttribute(blasLtMatrixLayout, blasLtMatrixLayoutAttribute, buf, workspaceSizeInBytes, &sizeWritten);
  status = cublasLtMatrixLayoutGetAttribute(blasLtMatrixLayout, blasLtMatrixLayoutAttribute, buf, workspaceSizeInBytes, &sizeWritten);
#endif

#if CUBLAS_VERSION >= 10200
  // CHECK: hipblasLtPointerMode_t blasLtPointerMode;
  // CHECK-NEXT: hipblasLtPointerMode_t BLASLT_POINTER_MODE_HOST = HIPBLASLT_POINTER_MODE_HOST;
  // CHECK-NEXT: hipblasLtPointerMode_t BLASLT_POINTER_MODE_DEVICE = HIPBLASLT_POINTER_MODE_DEVICE;
  cublasLtPointerMode_t blasLtPointerMode;
  cublasLtPointerMode_t BLASLT_POINTER_MODE_HOST = CUBLASLT_POINTER_MODE_HOST;
  cublasLtPointerMode_t BLASLT_POINTER_MODE_DEVICE = CUBLASLT_POINTER_MODE_DEVICE;
#endif

#if CUDA_VERSION >= 11000 && CUBLAS_VERSION >= 11000
  // CHECK: hipblasLtMatrixLayoutOpaque_t blasLtMatrixLayoutOpaque;
  cublasLtMatrixLayoutOpaque_t blasLtMatrixLayoutOpaque;

  // CHECK: hipblasLtMatmulDescOpaque_t blasLtMatmulDescOpaque;
  cublasLtMatmulDescOpaque_t blasLtMatmulDescOpaque;

  // CHECK: hipblasLtMatrixTransformDescOpaque_t blasLtMatrixTransformDescOpaque;
  cublasLtMatrixTransformDescOpaque_t blasLtMatrixTransformDescOpaque;

  // CHECK: hipblasLtMatmulPreferenceOpaque_t blasLtMatmulPreferenceOpaque;
  cublasLtMatmulPreferenceOpaque_t blasLtMatmulPreferenceOpaque;
#endif

#if CUDA_VERSION >= 11040 && CUBLAS_VERSION >= 11601
  // CHECK: hipblasLtPointerMode_t BLASLT_POINTER_MODE_ALPHA_DEVICE_VECTOR_BETA_HOST = HIPBLASLT_POINTER_MODE_ALPHA_DEVICE_VECTOR_BETA_HOST;
  cublasLtPointerMode_t BLASLT_POINTER_MODE_ALPHA_DEVICE_VECTOR_BETA_HOST = CUBLASLT_POINTER_MODE_ALPHA_DEVICE_VECTOR_BETA_HOST;
#endif
  return 0;
}
