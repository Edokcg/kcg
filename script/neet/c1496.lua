--霸王紫龙 异色眼猛毒龙-霸王(neet)
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsType,TYPE_FUSION),aux.FilterBoolFunctionEx(Card.IsType,TYPE_PENDULUM)) 
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit,nil,nil,nil,false)
	c:EnableReviveLimit()
	--Can only be Special Summoned once per turn
	c:SetSPSummonOnce(id)
	--pendulum summon
	Pendulum.AddProcedure(c,false)  
	--fus
	--注：原来的灵摆效果为:1回合1次，自己主要阶段才能发动。灵摆区域的这张卡特殊召唤，「凶饿毒」融合怪兽卡或者「捕食植物」融合怪兽卡决定的包含这张卡的融合素材怪兽从自己的手卡·场上送去墓地，把那1只融合怪兽从额外卡组融合召唤。
	--但是不知道怎样在这张卡特招前后都能被检查到 所以去掉了必须包含这张卡的限制 暂时不想继续研究 咕咕咕

	--local params = {s.fusfilter,Fusion.CheckWithHandler(aux.FALSE),nil,nil,Fusion.ForcedHandler}
	local params = {s.fusfilter,nil,nil,nil,nil}
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(s.sptg(Fusion.SummonEffTG(table.unpack(params))))
	e0:SetOperation(s.spop(Fusion.SummonEffTG(table.unpack(params)),Fusion.SummonEffOP(table.unpack(params))))
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.valcheck)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(function(e) return e:GetHandler():GetFlagEffect(id)>0 end)
	e2:SetValue(s.value)
	c:RegisterEffect(e2)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(s.pencon)
	e6:SetTarget(s.pentg)
	e6:SetOperation(s.penop)
	c:RegisterEffect(e6)
end
s.listed_series={0x10f3,0x1050}
function s.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or e:GetHandler():GetLocation()~=LOCATION_EXTRA 
end
function s.contactfil(tp)
	return Duel.GetReleaseGroup(tp)
end
function s.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function s.fusfilter(c)
	return c:IsSetCard(0x1050) or c:IsSetCard(0x10f3)
end
function s.sptg(fustg)
	return function (e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		end
		fustg(e,tp,eg,ep,ev,re,r,rp,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function s.spop(fustg,fusop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c or not c:IsRelateToEffect(e) then return end 
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and fustg(e,tp,eg,ep,ev,re,r,rp,0) then
			Duel.BreakEffect()
			fusop(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function s.valfilter(c)
	return c:IsType(TYPE_FUSION) and c:GetLevel()==10
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local mg=g:Filter(s.valfilter,nil)
	if #g>0 and #mg>0 then
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD&~(RESET_TOFIELD|RESET_LEAVE|RESET_TEMP_REMOVE),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
end
function s.value(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local val=g:GetSum(Card.GetBaseAttack)
	return val
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.penfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.penfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
