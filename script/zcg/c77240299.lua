--装甲 地炮 （ZCG）
function c77240299.initial_effect(c)
--Destroy
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c77240299.atkcon)
	e8:SetTarget(c77240299.atktg)
	e8:SetOperation(c77240299.atkop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_CHAINING)
	e9:SetCondition(c77240299.con)
	e9:SetTarget(c77240299.tg)
	e9:SetOperation(c77240299.op)
	c:RegisterEffect(e9)

	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77238982,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetOperation(c77240299.sop)
    c:RegisterEffect(e1)
end
function c77240299.con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and ep==1-tp
end
function c77240299.cocon(e)
   return e:GetHandler():GetFlagEffect(77240299)>0
end
function c77240299.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local count=eg:Filter(c77240299.atkfilter2,nil,tp):GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,count*2,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,count*2,0,0)
end
function c77240299.op(e,tp,eg,ep,ev,re,r,rp)
	local count=eg:Filter(c77240299.atkfilter2,nil,tp):GetCount()
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,count*2,count*2,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end

function c77240299.atkfilter2(c,tp)
	return c:IsControler(1-tp) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77240299.atkfilter(c,tp)
	return c:IsControler(1-tp) and c:IsOnField()
end
function c77240299.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77240299.atkfilter,1,nil,tp)
end
function c77240299.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local count=eg:Filter(c77240299.atkfilter,nil,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,#count*2,nil,TYPE_SPELL+TYPE_TRAP) end
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#count*2,0,0)
end
function c77240299.atkop(e,tp,eg,ep,ev,re,r,rp)
	local count=eg:Filter(c77240299.atkfilter,nil,tp)
	local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,#count*2,#count*2,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.Destroy(sg,REASON_EFFECT)
end

function c77240299.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
end