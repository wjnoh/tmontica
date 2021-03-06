package com.internship.tmontica.order.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@AllArgsConstructor
@Getter
public enum OrderExceptionType {
    INVALID_ORDER_ADD_FORM("order add form", "결제 요청 폼이 올바르지 않습니다", HttpStatus.BAD_REQUEST),
    INVALID_STATUS_FORM("status form", "주문상태 수정 폼이 올바르지 않습니다", HttpStatus.BAD_REQUEST),
    FORBIDDEN_ACCESS_ORDER_DATA("user id", "해당 주문 데이터에 권한이 없습니다", HttpStatus.FORBIDDEN),
    CANNOT_CANCEL_ORDER("order cancel", "주문을 취소할 수 없습니다", HttpStatus.BAD_REQUEST),
    INVALID_TOTALPRICE("order totalPrice", "요청한 전체 주문 금액이 맞지 않습니다", HttpStatus.BAD_REQUEST);


    private String field;
    private String message;
    private HttpStatus responseType;
}
