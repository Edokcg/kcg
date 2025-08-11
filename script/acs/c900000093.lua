--千年钥匙（AC）
function c900000093.initial_effect(c)
	
	--发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--对方场上盖伏的卡全部确认
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c900000093.target)
	e2:SetOperation(c900000093.operation)
	c:RegisterEffect(e2)
	
	--效果不会被无效化
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e3)
end

function c900000093.filter(c)
	return c:IsOnField() and c:IsFacedown()
end

function c900000093.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c900000093.filter,tp,0,LOCATION_ONFIELD,1,nil) end
end

function c900000093.operation(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(c900000093.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.ConfirmCards(tp,g)
end
