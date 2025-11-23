type Memory = {
	[number]: buffer,
	maximum: number,
}

type Table<T> = {
	[number]: T,
	minimum: number,
	maximum: number,
}

declare function rt_memory_new(initializer: { string }, minimum: number, maximum: number): Memory
declare function rt_subtract_i32(lhs: number, rhs: number): number
declare function rt_store_i32(destination: Memory, offset: number, source: number)
declare function rt_add_i32(lhs: number, rhs: number): number
declare function rt_not_equal_i32(lhs: number, rhs: number): boolean
declare function rt_load_i32(source: Memory, offset: number): number
declare function rt_equal_i32(lhs: number, rhs: number): boolean
declare function rt_exclusive_or_i32(...: number): number
declare function rt_shift_right_u32(lhs: number, rhs: number): number
declare function rt_and_i32(...: number): number
declare function rt_shift_left_i32(lhs: number, rhs: number): number
declare function rt_less_than_equal_u32(lhs: number, rhs: number): boolean
declare function rt_less_than_u32(lhs: number, rhs: number): boolean
declare function rt_multiply_i32(lhs: number, rhs: number): number
declare function rt_greater_than_equal_u32(lhs: number, rhs: number): boolean
declare function rt_table_new<T>(initializer: { T }, minimum: number, maximum: number): Table<T>
declare function rt_table_get<T>(source: Table<T>, offset: number): T
declare function rt_greater_than_u32(lhs: number, rhs: number): boolean
declare function rt_store_i32_into_i8(destination: Memory, offset: number, source: number)
declare function rt_create_u32_from_i64(source: number): (number, number)
declare function rt_store_i64(destination: Memory, offset: number, source: number)
declare function rt_create_i64_from_u32(source_1: number, source_2: number): number
declare function rt_load_i32_from_u16(source: Memory, offset: number): number
declare function rt_store_i32_into_i16(destination: Memory, offset: number, source: number)
declare function rt_load_i32_from_u8(source: Memory, offset: number): number
declare function rt_or_i32(...: number): number
declare function rt_memory_fill(destination: Memory, offset: number, source: number, size: number)
declare function rt_less_than_s32(lhs: number, rhs: number): boolean
declare function rt_load_f64(source: Memory, offset: number): number
declare function rt_store_f64(destination: Memory, offset: number, source: number)
declare function rt_absolute_f64(source: number): number
declare function rt_round_up_f64(source: number): number
declare function rt_divide_f64(lhs: number, rhs: number): number
declare function rt_round_down_f64(source: number): number
declare function rt_saturate_f64_to_s32(source: number): number
declare function rt_equal_f64(lhs: number, rhs: number): boolean
declare function rt_less_than_f64(lhs: number, rhs: number): boolean
declare function rt_greater_than_f64(lhs: number, rhs: number): boolean
declare function rt_multiply_f64(lhs: number, rhs: number): number
declare function rt_square_root_f64(source: number): number
declare function rt_convert_u32_to_f64(source: number): number
declare function rt_shift_right_s32(lhs: number, rhs: number): number
declare function rt_create_u32_from_i64_1(source: number): number
declare function rt_narrow_i64(source: number): number
declare function rt_truncate_f64_to_u64_unchecked(source: number): number
declare function rt_saturate_f64_to_s64(source: number): number
declare function rt_less_than_equal_s32(lhs: number, rhs: number): boolean
declare function rt_greater_than_s32(lhs: number, rhs: number): boolean
declare function rt_rotate_left_i32(lhs: number, rhs: number): number
declare function rt_rotate_right_i32(lhs: number, rhs: number): number
declare function rt_less_than_equal_f64(lhs: number, rhs: number): boolean
declare function rt_store_f32(destination: Memory, offset: number, source: vector)
declare function rt_narrow_f64(source: number): vector
declare function rt_add_f64(lhs: number, rhs: number): number
declare function rt_subtract_f64(lhs: number, rhs: number): number
declare function rt_not_equal_f64(lhs: number, rhs: number): boolean
declare function rt_load_i64(source: Memory, offset: number): number
declare function rt_divide_s32(lhs: number, rhs: number): number
declare function rt_memory_copy(destination: Memory, offset_1: number, source: Memory, offset_2: number, size: number)
declare function rt_negate_f64(source: number): number
declare function rt_load_f32(source: Memory, offset: number): vector
declare function rt_negate_f32(source: vector): vector
declare function rt_add_f32(lhs: vector, rhs: vector): vector
declare function rt_subtract_f32(lhs: vector, rhs: vector): vector
declare function rt_multiply_f32(lhs: vector, rhs: vector): vector
declare function rt_equal_f32(lhs: vector, rhs: vector): boolean
declare function rt_not_equal_f32(lhs: vector, rhs: vector): boolean
declare function rt_divide_f32(lhs: vector, rhs: vector): vector
declare function rt_round_down_f32(source: vector): vector
declare function rt_load_i32_from_s8(source: Memory, offset: number): number
declare function rt_greater_than_equal_s32(lhs: number, rhs: number): boolean
declare function rt_greater_than_equal_f64(lhs: number, rhs: number): boolean
declare function rt_remainder_u32(lhs: number, rhs: number): number
declare function rt_saturate_f64_to_u32(source: number): number
declare function rt_divide_u32(lhs: number, rhs: number): number
declare function rt_equal_i64(lhs: number, rhs: number): boolean
declare function rt_not_equal_i64(lhs: number, rhs: number): boolean
declare function rt_create_u32_from_i64_2(source: number): number
declare function rt_shift_right_u64(lhs: number, rhs: number): number
declare function rt_widen_i32(source: number): number
declare function rt_extend_s16_to_i32(source: number): number
declare function rt_store_i64_into_i8(destination: Memory, offset: number, source: number)
declare function rt_less_than_u64(lhs: number, rhs: number): boolean
declare function rt_greater_than_equal_u64(lhs: number, rhs: number): boolean
declare function rt_leading_zeroes_i32(source: number): number
declare function rt_extend_s8_to_i32(source: number): number
declare function rt_shift_left_i64(lhs: number, rhs: number): number
declare function rt_add_i64(lhs: number, rhs: number): number
declare function rt_convert_s32_to_f64(source: number): number
declare function rt_and_i64(lhs: number, rhs: number): number
declare function rt_or_i64(lhs: number, rhs: number): number
declare function rt_subtract_i64(lhs: number, rhs: number): number
declare function rt_create_u16_from_i64(source: number): (number, number, number, number)
declare function rt_truncate_f64_to_u64(source: number): number
declare function rt_multiply_fast_i64(lhs: number, rhs: number): number
declare function rt_multiply_i64(lhs: number, rhs: number): number
declare function rt_extend_s32_to_i64(source: number): number
declare function rt_greater_than_u64(lhs: number, rhs: number): boolean
declare function rt_less_than_equal_u64(lhs: number, rhs: number): boolean
declare function rt_flip_sign_bit_i64(source: number): number
declare function rt_less_than_s64(lhs: number, rhs: number): boolean
declare function rt_transmute_f64_to_i64(source: number): number
declare function rt_rotate_left_i64(lhs: number, rhs: number): number
declare function rt_store_i64_into_i32(destination: Memory, offset: number, source: number)
declare function rt_load_i64_from_u32(source: Memory, offset: number): number
declare function rt_exclusive_or_i64(lhs: number, rhs: number): number
declare function rt_convert_u64_to_f64(source: number): number
declare function rt_saturate_f64_to_u64(source: number): number
declare function rt_greater_than_equal_s64(lhs: number, rhs: number): boolean
declare function rt_greater_than_s64(lhs: number, rhs: number): boolean
declare function rt_less_than_equal_s64(lhs: number, rhs: number): boolean
declare function rt_transmute_i64_to_f64(source: number): number
declare function rt_create_f64_from_u32(source_1: number, source_2: number): number
declare function rt_trailing_zeroes_i32(source: number): number
declare function rt_memory_size(source: Memory): number
declare function rt_raw_leading_zeroes_i64(source: number): number
declare function rt_leading_zeroes_i64(source: number): number
declare function rt_transmute_f32_to_i32(source: vector): number
declare function rt_copy_sign_f64(lhs: number, rhs: number): number
declare function rt_convert_s32_to_f32(source: number): vector
declare function rt_transmute_i32_to_f32(source: number): vector
declare function rt_remainder_s32(lhs: number, rhs: number): number
declare function rt_is_zero_i64(source: number): boolean
declare function rt_divide_u64(lhs: number, rhs: number): (number, number)
declare function rt_load_i64_from_s16(source: Memory, offset: number): number
declare function rt_load_i64_from_u16(source: Memory, offset: number): number
declare function rt_load_i64_from_s8(source: Memory, offset: number): number
declare function rt_load_i64_from_u8(source: Memory, offset: number): number
declare function rt_load_i64_from_s32(source: Memory, offset: number): number
declare function rt_table_set<T>(destination: Table<T>, offset: number, source: T)
declare function rt_table_copy<T>(destination: Table<T>, offset_1: number, source: Table<T>, offset_2: number, size: number)
declare function rt_table_drop<T>(destination: Table<T>)
declare function rt_memory_drop(destination: Memory)
