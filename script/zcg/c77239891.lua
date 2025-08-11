--深渊海怪 鱼头师令(ZCG)
function c77239891.initial_effect(c)
    Pendulum.AddProcedure(c)
	
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)	
    e1:SetDescription(aux.Stringid(77239891,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1)	
    e1:SetTarget(c77239891.destg)
    e1:SetOperation(c77239891.desop)
    c:RegisterEffect(e1)

    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c77239891.destg1)
    e2:SetOperation(c77239891.desop1)
    c:RegisterEffect(e2)	
end
---------------------------------------------------------------------------------------
function c77239891.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
--[[function c77239891.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c77239891.filter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingTarget(c77239891.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c77239891.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
    g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c77239891.desop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(Group.FromCards(tc,e:GetHandler()),REASON_EFFECT)
    end
end]]
function c77239891.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c77239891.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c77239891.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77239891.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239891.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
---------------------------------------------------------------------------------------
function c77239891.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239891.desop1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
