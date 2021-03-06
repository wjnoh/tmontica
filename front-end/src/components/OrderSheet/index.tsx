import * as React from "react";
import OrderSheetItem from "../OrderSheetItem";
import "./styles.scss";
import { getOrderById } from "../../api/order";
import { TOrderDetail } from "../../types/menu";
import _ from "underscore";
import history from "../../history";
import { PureComponent } from "react";
import { TOrder } from "../../types/order";
import { CommonError } from "../../api/CommonError";
import { handleError } from "../../api/common";
import { ISignoutFunction } from "../../types/user";

export interface IOrderSheetProps extends ISignoutFunction {
  orderId: number;
  handleOrderCancle(order: TOrder): Promise<any>;
}

export interface IOrderSheetState {
  order: TOrder;
}

class OrderSheet extends PureComponent<IOrderSheetProps, IOrderSheetState> {
  state = {
    order: {} as TOrder
  };

  intervalId = {} as NodeJS.Timeout;

  async getOrder() {
    try {
      if (this.props.orderId <= 0) {
        return;
      }

      let order = await getOrderById(this.props.orderId);

      if (!order) throw new CommonError({ status: 500, message: "주문정보가 없습니다." });
      if (order instanceof CommonError) throw order;

      this.setState({
        order
      });
    } catch (error) {
      const result = await handleError(error);
      if (result === "signout") {
        this.props.signout();
      } else {
        history.push("/");
      }
    }
  }

  componentDidMount() {
    if (this.props.orderId > 0) {
      this.getOrder();
    }
    // 10초마다 주문정보 갱신
    this.intervalId = setInterval(() => {
      this.getOrder();
    }, 10000);
  }

  componentDidUpdate(prevProps: IOrderSheetProps) {
    // 주문번호가 다른 경우 요청
    if (this.props.orderId !== prevProps.orderId) {
      this.getOrder();
    }
  }

  componentWillUnmount() {
    // 나갈 때 인터벌 제거
    clearInterval(this.intervalId);
  }

  handleCancle = async () => {
    if (window.confirm("취소하시겠습니까?")) {
      try {
        const order = await this.props.handleOrderCancle(this.state.order);

        this.setState({
          order: { ...order }
        });
      } catch (error) {}
    }
  };

  statusCode = {
    미결제: 0,
    결제완료: 1,
    준비중: 2,
    준비완료: 3,
    READY: 3,
    픽업완료: 4,
    주문취소: 5
  } as { [key: string]: number };

  fromStatusCode = {
    0: "미결제",
    1: "결제완료",
    2: "준비중",
    3: "준비완료",
    4: "픽업완료",
    5: "주문취소"
  } as { [key: number]: string };

  render() {
    const { statusCode, fromStatusCode } = this;
    const { order } = this.state;
    const { orderId } = this.props;
    const isReadyOrder = orderId > 0;
    const statusArray = [];

    if (isReadyOrder) {
      // 현재 상태와 6가지 상태를 비교해 색상 배열 생성
      for (let i = 0; i < 6; i++) {
        if (i < statusCode[order.status]) {
          statusArray.push(0);
        } else if (i === statusCode[order.status]) {
          statusArray.push(1);
        } else {
          statusArray.push(2);
        }
      }
    }

    return (
      <section className={`orders ${!Number.isInteger(order.orderId) ? "hide" : ""}`}>
        <div className={`orders__top`}>
          <h1 className="orders__top-title">주문서({order.orderId})</h1>
          {}
          <span className="orders__top-cancel" onClick={this.handleCancle}>
            주문취소
          </span>
        </div>
        <div className="orders__content">
          <ul className="orders__status-container">
            {isReadyOrder
              ? statusArray.map((s, index) => {
                  if (s === 0) {
                    return (
                      <li key={index} className="orders__status orders__status--gray">
                        {fromStatusCode[index]}
                      </li>
                    );
                  } else if (s === 1) {
                    return (
                      <li
                        key={index}
                        className={`orders__status orders__status--${
                          statusCode[order.status] === 5 ? "red" : "green"
                        }`}
                      >
                        {fromStatusCode[index]}
                      </li>
                    );
                  } else {
                    return (
                      <li key={index} className="orders__status">
                        {fromStatusCode[index]}
                      </li>
                    );
                  }
                })
              : ""}
          </ul>
          <OrderSheetList order={order} />
          <div className="orders__total">
            <div className="orders__total-price">
              주문금액 - {Number(order.totalPrice).toLocaleString()}원
            </div>
            <div className="orders__total-discount">
              할인금액 - {Number(order.usedPoint).toLocaleString()}원
            </div>
            <div className="orders__total-result">
              최종금액 - {Number(order.realPrice).toLocaleString()}원
            </div>
          </div>
        </div>
      </section>
    );
  }
}

interface IOrderSheetListProps {
  order: TOrder;
}

class OrderSheetList extends PureComponent<IOrderSheetListProps> {
  render() {
    const { order } = this.props;

    return (
      <ul className="orders__items">
        {_(order.menus).map((m: TOrderDetail, i) => {
          return (
            <OrderSheetItem
              key={`${order.orderId}_${i}`}
              name={m.nameKo}
              price={m.sellPrice}
              option={m.option}
              quantity={m.quantity}
              imgUrl={m.imgUrl}
            />
          );
        })}
      </ul>
    );
  }
}
export default OrderSheet;
