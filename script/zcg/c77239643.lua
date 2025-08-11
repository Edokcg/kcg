--植物的愤怒 绿能转化
function c77239643.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --return
    local e2=Effect.CreateEffect(c)
    --e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCondition(c77239643.recon)
    --e2:SetTarget(c77239643.retg)
    e2:SetOperation(c77239643.reop)
    c:RegisterEffect(e2)

    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239643,2))
    e3:SetCategory(CATEGORY_CONTROL)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c77239643.con)	
    e3:SetTarget(c77239643.target)
    e3:SetOperation(c77239643.activate)
    c:RegisterEffect(e3)
end
------------------------------------------------------------------
--[[function c77239643.filter(c,e,tp)
    return c:IsReason(REASON_DESTROY+REASON_BATTLE) and c:IsSetCard(0xa90) and c:GetControler()==tp
    and c:GetPreviousControler()==tp and c:IsCanBeEffectTarget(e) and c:IsAbleToDeck()
end
function c77239643.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return eg:IsContains(chkc) and c77239643.filter(chkc,e,tp) end
    if chk==0 then return eg:IsExists(c77239643.filter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=eg:FilterSelect(tp,c77239643.filter,1,1,nil,e,tp)
    Duel.SetTargetCard(g)
end
function c77239643.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()	
    if tc:IsRelateToEffect(e) then
	    local op=Duel.SelectOption(tp,aux.Stringid(77239643,0),aux.Stringid(77239643,1))
        if op==2 then
		    Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		else
		    Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)		
		end
    end
end]]
function c77239643.ctfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0xa90)
end
function c77239643.recon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77239643.ctfilter,1,nil)
end
function c77239643.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c77239643.ctfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()~=0 then
		if Duel.SelectOption(1-tp,aux.Stringid(77239643,0),aux.Stringid(77239643,1))==0 then
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		else
			Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		end
	end
end
------------------------------------------------------------------
function c77239643.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa90) and c:IsType(TYPE_MONSTER) 
end
function c77239643.con(e,c)
    if c==nil then return true end
    return Duel.IsExistingMatchingCard(c77239643.spfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,2,nil)
end
function c77239643.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c77239643.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp)
    end
end

