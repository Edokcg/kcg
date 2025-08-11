--No.99 Hope Dragoon
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,10,3,s.ovfilter,aux.Stringid(51543904,0),3,s.xyzop)
	c:EnableReviveLimit()

	--cannot destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(s.indes)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2067935,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)

	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15240238,0))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost)
	e3:SetCondition(s.descondition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3,false,EFFECT_MARKER_DETACH_XMAT)
end
s.xyz_number=99
s.listed_series={0x95,0x48}

function s.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSetCard(0x107f,lc,SUMMON_TYPE_XYZ,tp)
end
function s.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND,0,nil):SelectUnselect(Group.CreateGroup(),tp,false,Xyz.ProcCancellable)
	if tc then
		Duel.SendtoGrave(tc,REASON_DISCARD+REASON_COST)
		return true
	else return false end
end

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and (c:IsSetCard(0x48) or c:IsSetCard(0x1048) or c:IsSetCard(0x2048))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		  Duel.SpecialSummonComplete() 
	  end end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.descondition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_CONTROL)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	return eb and tg and tg:IsContains(e:GetHandler())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
		local dg=Duel.GetOperatedGroup()
		local sum=dg:GetSum(Card.GetAttack)
		Duel.Damage(1-tp,sum,REASON_EFFECT)
	end
end